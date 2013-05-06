CC := gcc
LD := ld
OBJCOPY := objcopy
GDB := gdb
QEMU := qemu-system-i386
DISK_IMAGE = haribote.img

TEXT_START=0x00280000
DATA_START=0x00310000

# If you don't need list file, comment out the following
LIST = -Wa,-a=$(@:.o=.lst)

all: $(DISK_IMAGE)

dump: $(DISK_IMAGE)
	hexdump -C $<

run: $(DISK_IMAGE)
	$(QEMU) -fda $< &

debug: $(DISK_IMAGE) gdb_script.txt
	$(QEMU) -S -s -fda $< &
	$(GDB) -q -s ipl10.out -x gdb_script.txt

$(DISK_IMAGE): ipl10.bin haribote_sys.img
	dd if=ipl10.bin of=$@
	dd if=haribote_sys.img of=$@ bs=512 skip=1 seek=1

haribote_sys.img: empty.img haribote.sys
	cp empty.img $@
	mkdir tmp
	sudo mount -t msdos -o loop $@ tmp/
	sudo cp haribote.sys tmp
	sleep 1
	sudo umount tmp
	rm -rf tmp

ipl10.out: ipl10.lds ipl10.o
	$(LD) -o $@ -T ipl10.lds ipl10.o

haribote.sys: asmhead.bin bootpack.hrb
	cat asmhead.bin bootpack.hrb > $@

asmhead.out: asmhead.lds asmhead.o
	$(LD) -o $@ -T asmhead.lds asmhead.o

bootpack.hrb: bootpack.out bootpack.bin Makefile
	data_size=0x0$$(objdump -h $< | awk '/.data/ {print $$3}'); \
	data_lma=0x0$$(objdump -h $< | awk '/.data/ {print $$5}'); \
	bss_size=0x0$$(objdump -h $< | awk '/.bss/ {print $$3}'); \
	entry_point=$$(readelf -h $< | sed -n -e 's/[[:blank:]]*Entry point address:[[:blank:]]*\(.*\)/\1/p'); \
	perl -e "print pack('LA4LLLLLLL', $(DATA_START) + $$data_size + $$bss_size, 'Hari', 0, $(DATA_START), \
	$$data_size, $$data_lma, 0xe9000000, $$entry_point - $(TEXT_START) + 4, 0);" > $@
	cat bootpack.bin >> $@

bootpack.out: bootpack.lds bootpack.o Makefile
	$(LD) -m elf_i386 -o $@ -T bootpack.lds -Tdata $(DATA_START) bootpack.o

empty.img:
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkdosfs $@

bootpack.bin: bootpack.out Makefile
	$(OBJCOPY) -R .eh_frame -O binary bootpack.out $@

%.bin: %.out
	$(OBJCOPY) -O binary $< $@

%.o: %.S
	$(CC) $(LIST) -c -o $@ $<

%.o: %.c
	$(CC) -m32 $(LIST) -c -o $@ $<

clean:
	rm -f *.img *.out *.bin *.o *.lst *.sys *.hrb

distclean: clean
	rm -f *~

.PHONY: all dump run debug clean distclean
