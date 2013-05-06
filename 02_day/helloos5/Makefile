CC := gcc
LD := ld
OBJCOPY := objcopy
GDB := gdb
QEMU := qemu-system-i386
DISK_IMAGE := helloos.img

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

$(DISK_IMAGE): ipl.bin empty.img
	dd if=ipl.bin of=$@
	dd if=empty.img of=$@ bs=512 skip=1 seek=1

ipl.out: ipl.lds ipl.o
	$(LD) -o $@ -T ipl.lds ipl.o

empty.img:
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkdosfs $@

%.bin: %.out
	$(OBJCOPY) -O binary $< $@

%.o: %.S
	$(CC) -g $(LIST) -c -o $@ $<

clean:
	rm -f *.img *.out *.bin *.o *.lst

distclean: clean
	rm -f *~

.PHONY: all dump run debug clean distclean
