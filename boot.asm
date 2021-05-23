[bits 16]

section .boot_code
mov sp, 0xba00
call setup_print
push boot_string
call print_string
push 100
push 100
push 0x7
call draw_point
jmp $
%include "boot_routines/print.asm"
times 5120 - ($ - $$) db 0

section .boot_data
boot_string db "Preparing Osgiliath for the invasion", 0
times 5120 - ($ - $$) db 0

section .boot0_code
global _start
_start:
	mov ah, 2
	mov al, 20
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov bx, 0x7e0
	mov es, bx
	mov bx, 0
	int 0x13

	jmp 0x7e00

times 510 - ($ - $$) db 0
dw 0xaa55
