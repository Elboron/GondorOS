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
push 6
push 4
call move_cursor
input_loop:
	call wait_read_input
	cmp ax, 0x0f09
	je proceed_tab
	jmp input_loop
	proceed_tab:
		cmp byte [current_selected], -1
		je render_select
		mov ax, 4
		add ax, [current_selected]
		push ax
		push 30
		call move_cursor
		push clear_select_string
		call print_string
		render_select:
		mov al, [current_selected]
		cmp al, [num_options]
		je max_options
		inc byte [current_selected]
		jmp continue
		max_options:
			mov byte [current_selected], 0
			jmp continue
		continue:
		mov ax, 4
		add ax, [current_selected]
		push ax
		push 30
		call move_cursor
		push selected_string
		call print_string
		jmp input_loop
jmp $
%include "boot_routines/print.asm"
%include "boot_routines/keyboard.asm"
times 5120 - ($ - $$) db 0

section .boot_data
boot_string db "Preparing Osgiliath for the invasion", 0
gondor_os_start_string db "Boot GondorOS", 0
reboot_string db "Reboot your computer", 0
selected_string db "SELECT", 0
clear_select_string db "      ", 0
num_options db 1
current_selected db -1
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
