	.code32
	.section .text

.global	io_hlt
io_hlt:
	hlt
	ret
.global write_mem8
write_mem8:
	mov	4(%esp), %ecx
	mov	8(%esp), %al
	mov	%al, (%ecx)
	ret
