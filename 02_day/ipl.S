.code16
	.section .text
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
	movw	%ax, %es
	movw	$msg, %si
putloop:
	mov	(%si), %al
	add	$1, %si
	cmp	$0, %al
	je	fin
	movb	$0x0e, %ah	# 一文字表示ファンクション
	movw	$15, %bx	# カラーコード
	int	$0x10	# ビデオBIOS呼び出し
	jmp	putloop
fin:
	hlt		# 何かあるまでCPUを停止させる
	jmp	fin
msg:
	.asciz	"\n\nhello, world\n"
	.org 0x1fe
	.byte	0x55, 0xaa
