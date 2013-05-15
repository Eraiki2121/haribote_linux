	.code32
	.section .text

.global	io_hlt
io_hlt: # void io_hlt(void);
	hlt
	ret

.global 
io_cli:	# void io_cli(void);
	cli
	ret

.global 
io_sti:	# void io_sti(void);
	sti
	ret

.global 
io_stihlt: # void io_stihlt(void);
	sti
	hlt
	ret

.global 
io_in8:	# int io_in8(int port);
	mov 4(%esp), %edx		# port
	mov $0, %eax
	in %dx, %al
	ret

.global 
io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

.global
io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

.global
io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

.global
io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

.global
io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

.global
io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS という意味
		POP		EAX
		RET

.global
io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS という意味
		RET
