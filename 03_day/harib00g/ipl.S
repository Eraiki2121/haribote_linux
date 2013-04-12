.code16
	.section .text

	.equ	CYLS,	10	# number of cylinders to load
	
	.byte	0xeb, 0x4e, 0x90
	.ascii	"HELLOIPL"
	.word	512
	.byte	1
	.word	1
	.byte	2
	.word	224
	.word	2880
	.byte	0xf0
	.word	9
	.word	18
	.word	2		# ヘッドの数（2にしなければいけない）
	.long	0		# パーティションを使ってないのでここは必ず0
	.long	2880		# このドライブ大きさをもう一度書く
	.byte	0,0,0x29	# よくわからないけどこの値にしておくといいらしい
	.long	0xffffffff	# たぶんボリュームシリアル番号
	.ascii	"HELLO-OS   "	# disk name (11 byte)
	.ascii	"FAT12   "	# format name (8 byte)
	.fill	18

entry:
	movw	$0, %ax			# レジスタ初期化
	movw	%ax, %ss
	movw	$0x7c00, %sp
	movw	%ax, %ds

# ディスクを読む

	movw	$0x0820, %ax
	movw	%ax, %es # buffer segment
	movb	$0, %ch	# cylinder[7:0]
	movb	$0, %dh	# head[7:0]
	movb	$2, %cl # {cylinder[9:8], sector[5:0]}
readloop:
	movw	0, %si	# couter for retry
retry:
	movb	$2, %ah # 2 = read, 3 = write, 4 = verify
	movb	$1, %al # nr_sectors
	movw	$0, %bx # buffer offset
	movb	$0, %dl # drive number
	int	$0x13	# call disk BIOS
	jnc	next	# go to next on success
	add	$1, %si
	cmp	$5, %si
	jae	error
	mov	$0, %ah
	mov	$0, %dl	# A drive
	int	$0x13	# reset drive
	jmp	retry
next:
	movw	%es, %ax
	add	$0x20, %ax	# increment address by 0x200
	movw	%ax, %es
	add	$1, %cl
	cmp	$18, %cl	# read until sector 18
	jbe	readloop
	movb	$1, %cl
	add	$1, %dh
	cmp	$2, %dh
	jb	readloop
	movb	$0, %dh
	add	$1, %ch
	cmp	CYLS, %ch
	jb	readloop

# jump to haribote.sys
	mov	%ch, (0x0ff0)
	jmp	0xc400

error:
	movw	$0, %ax
	movw	%ax, %es
	movw	$msg, %si
putloop:
	mov	(%si), %al
	add	$1, %si
	cmp	$0, %al
	je	fin
	movb	$0x0e, %ah	# 一文字表示ファンクション
	movw	$15, %bx	# color code
	int	$0x10	# call Video BIOS
	jmp	putloop
fin:
	hlt
	jmp	fin
msg:
	.asciz	"\n\nload error\n"
	.org 0x1fe
	.byte	0x55, 0xaa
