CC := gcc
LD := ld
OBJCOPY := objcopy
GDB := gdb
QEMU := qemu-system-i386

obj-y := ipl.o

all: fd.img

dump: ipl.bin
	hexdump -C $<

run: fd.img
	$(QEMU) -fda $< &

debug: fd.img ipl.gdb
	$(QEMU) -S -s -fda $< &
	$(GDB) -q -s ipl.out -x ipl.gdb

fd.img: ipl.bin fd_empty.img
	dd if=ipl.bin of=$@
	dd if=fd_empty.img of=$@ bs=512 skip=1 seek=1

ipl.bin: ipl.out
	$(OBJCOPY) -O binary $< $@

ipl.out: ipl.lds $(obj-y)
	$(LD) -o $@ -T ipl.lds $(obj-y)

%.o: %.c
	$(CC) -c -o $@ $<

%.o: %.S
	$(CC) -Wa,-a=$(@:.o=.lst) -c -o $@ $<

fd_empty.img:
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkdosfs $@

clean:
	rm -f *.img *.out *.bin *.o *.lst

distclean: clean
	rm -f *~

.PHONY: all dump run clean distclean
