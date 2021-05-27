[bits 16]

section .boot_code
mov sp, 0x7bff
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
	cmp ax, 0x1c0d
	je proceed_enter
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
	proceed_enter:
		cmp byte [current_selected], 1
		je reboot
		cmp byte [current_selected], 0
		je boot_kernel
		jmp input_loop
	reboot:
		lidt [0]
		int 3
	boot_kernel:
		jmp 0x8600
jmp $
%include "boot_routines/print.asm"
%include "boot_routines/keyboard.asm"
times 1024 - ($ - $$) db 0

section .boot_data
boot_string db "Preparing Osgiliath for the invasion", 0
gondor_os_start_string db "Boot GondorOS", 0
reboot_string db "Reboot your computer", 0
selected_string db "SELECT", 0
clear_select_string db "      ", 0
num_options db 1
current_selected db -1

;GLOBAL DESCRIPTOR TABLE
gdt_start:
;NULL descriptor
dq 0
;CODE Descriptor
;G = 1, 4GB / 4KB = 1048576 => 0x100000
dw 0x0000	;Segment Limit 0-15
;Descriptor covers 0 -> 4GB => Basic Flat model
dw 0x0	;Base Address 0-15
db 0x0	;Base Address 16-23
;Type: code segment, execute/read => 1010, S: Code/Data => 1, DPL: 00, P: Present in Memory => 1
db 0b10011010	;Type(4), S(1), DPL(2), P(1)
;SegLimit: 0x10 -> 0b10000, AVL: (0?), L: 32bit -> 0, D/B: D->32bit Addresses => 1, G: 4KB steps => 1
db 0b11001111	;SegLimit(4), AVL(1), L(1), D/B(1), G(1)
db 0x0	;Base Address 24-31
;DATA Descriptor
dw 0x0000
dw 0x0
db 0x0
;Type: data segment, read/write => 0010
db 0b10010010
db 0b11001111
db 0x0
;STACK Descriptor
dw 0x0000
dw 0x0
db 0x0
;Type: data segment, read/write/expand down => 0110
db 0b10010110
db 0b11001111
db 0x0

gdt_descriptor:
db 0
dw gdt_start
dw 24

times 1024 - ($ - $$) db 0

section .boot0_code
global _start
_start:
	mov ah, 2
	mov al, 4
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov bx, 0x7e0
	mov es, bx
	mov bx, 0
	int 0x13

	mov ah, 2
	mov al, 40
	mov ch, 0
	mov cl, 6
	mov dh, 0
	mov bx, 0x860
	mov es, bx
	mov bx, 0
	int 0x13

	jmp 0x7e00

times 510 - ($ - $$) db 0
dw 0xaa55
