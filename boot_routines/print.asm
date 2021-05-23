bits 16]
setup_write:
	mov al, 0x02
	mov ah, 0x0
	int 0x10
	ret

setup_print:
	;320x200 256 Color Graphics MVCGA, VGA
	mov al, 0x13
	mov ah, 0x0
	int 0x10
	ret

draw_point:
	;point_x, point_y, color
	mov bx, sp
	mov ah, 0xc
	mov al, [bx + 2]
	mov cx, [bx + 4]
	mov dx, [bx + 6]
	mov bh, 0
	int 0x10
	ret

draw_line_v:
	;start_x, start_y, end_y, color
	ret

draw_line_h:
	;start_X, start_y, end_x, color
	ret

print_char:
	push bx
	mov bx, sp
	mov ax, [bx + 4]
	mov ah, 0x0e
	int 0x10
	pop bx
	ret

print_string:
	mov bx, sp ;Mov param into bx for indexing
	mov bx, [bx + 2] ;Mov address of string into bx
	xor si, si ;Use si for indexing current char
	loop:
		mov al, [bx + si]
		cmp al, 0
		je finished
		push ax
		call print_char
		pop ax
		add si, 1
		jmp loop
	finished:
		ret
