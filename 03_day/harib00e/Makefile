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

$(DISK_IMAGE): ipl.bin haribote.sys
	../../tools/mk_fdimage.py -b ipl.bin $@ haribote.sys

ipl.out: ipl.lds ipl.o
	$(LD) -o $@ -T ipl.lds ipl.o

haribote.out: haribote.lds haribote.o
	$(LD) -o $@ -T haribote.lds haribote.o

%.bin: %.out
	$(OBJCOPY) -O binary $< $@

%.sys: %.out
	$(OBJCOPY) -O binary $< $@

%.o: %.S
	$(CC) -g $(LIST) -c -o $@ $<

clean:
	rm -f *.img *.out *.bin *.o *.lst *.sys

distclean: clean
	rm -f *~

.PHONY: all dump run debug clean distclean
