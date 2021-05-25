[bits 16]

section .boot_code
mov sp, 0xba00
call setup_print
push 1
push 1
call move_cursor
push boot_string
call print_string
push 24
push 24
push 294
push 174
push 0x7
call draw_square
push 4
push 5
call move_cursor
push gondor_os_start_string
call print_string
push 5
push 5
call move_cursor
push reboot_string
call print_string
jmp $
%include "boot_routines/print.asm"
times 5120 - ($ - $$) db 0

section .boot_data
boot_string db "Preparing Osgiliath for the invasion", 0
gondor_os_start_string db "Boot GondorOS", 0
reboot_string db "Reboot your computer", 0
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
