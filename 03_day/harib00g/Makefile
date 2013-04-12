CC := gcc
LD := ld
OBJCOPY := objcopy
GDB := gdb
QEMU := qemu-system-i386

obj-y := ipl.o

all: haribote.img

dump: ipl.bin
	hexdump -C $<

run: haribote.img
	$(QEMU) -fda $< &

debug: haribote.img ipl.gdb
	$(QEMU) -S -s -fda $< &
	$(GDB) -q -s ipl.out -x ipl.gdb

haribote.img: ipl.bin haribote.sys fd_empty.img
	cp fd_empty.img __tmp.img
	rm -rf tmp
	mkdir tmp
	sudo mount -t msdos -o loop __tmp.img tmp
	sudo cp haribote.sys tmp
	sleep 1
	sudo umount tmp
	dd if=ipl.bin of=$@
	dd if=__tmp.img of=$@ bs=512 skip=1 seek=1
	rm __tmp.img
	rmdir tmp

ipl.bin: ipl.out
	$(OBJCOPY) -O binary $< $@

ipl.out: ipl.lds $(obj-y)
	$(LD) -o $@ -T ipl.lds $(obj-y)

haribote.sys: haribote.out
	$(OBJCOPY) -O binary $< $@

haribote.out: haribote.lds haribote.o
	$(LD) -o $@ -T haribote.lds haribote.o

%.o: %.c
	$(CC) -c -o $@ $<

%.o: %.S
	$(CC) -Wa,-a=$(@:.o=.lst) -c -o $@ $<

fd_empty.img:
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkdosfs $@

clean:
	rm -f *.img *.out *.bin *.o *.lst *.sys

distclean: clean
	rm -f *~

.PHONY: all dump run clean distclean
