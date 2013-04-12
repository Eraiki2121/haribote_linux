CC := gcc
LD := ld
OBJCOPY := objcopy
GDB := gdb
QEMU := qemu-system-i386
DISK_IMAGE = haribote.img

# If you don't need list file, comment out the following
LIST = -Wa,-a=$(@:.o=.lst)

all: $(DISK_IMAGE)

dump: $(DISK_IMAGE)
	hexdump -C $<

run: $(DISK_IMAGE)
	$(QEMU) -fda $< &

debug: $(DISK_IMAGE) gdb_script.txt
	$(QEMU) -S -s -fda $< &
	$(GDB) -q -s ipl.out -x gdb_script.txt

$(DISK_IMAGE): ipl.bin haribote_sys.img
	dd if=ipl.bin of=$@
	dd if=haribote_sys.img of=$@ bs=512 skip=1 seek=1

haribote_sys.img: empty.img haribote.sys
	cp empty.img $@
	mkdir tmp
	sudo mount -t msdos -o loop $@ tmp/
	sudo cp haribote.sys tmp
	sleep 1
	sudo umount tmp
	rm -rf tmp

ipl.out: ipl.lds ipl.o
	$(LD) -o $@ -T ipl.lds ipl.o

haribote.out: haribote.lds haribote.o
	$(LD) -o $@ -T haribote.lds haribote.o

empty.img:
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkdosfs $@

%.bin: %.out
	$(OBJCOPY) -O binary $< $@

%.sys: %.out
	$(OBJCOPY) -O binary $< $@

%.o: %.S
	$(CC) $(LIST) -c -o $@ $<

clean:
	rm -f *.img *.out *.bin *.o *.lst *.sys

distclean: clean
	rm -f *~

.PHONY: all dump run debug clean distclean
