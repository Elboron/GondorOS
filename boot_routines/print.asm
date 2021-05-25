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
	push ax
	push bx
	push cx
	push dx
	mov ah, 0xc
	mov al, [bx + 2]
	mov cx, [bx + 6]
	mov dx, [bx + 4]
	mov bh, 0
	int 0x10
	pop dx
	pop cx
	pop bx
	pop ax
	ret

draw_line_v:
	;start_x, start_y, end_y, color
	push bx
	mov bx, sp
	draw_line_v_loop:
		inc word [bx + 8]
		push bx
		push word [bx + 10]
		push word [bx + 8]
		push word [bx + 4]
		call draw_point
		pop ax
		pop ax
		pop ax
		pop bx
		mov ax, [bx + 6]
		cmp ax, [bx + 8]
		je draw_line_v_finished
		jmp draw_line_v_loop
	draw_line_v_finished:
		pop bx
		ret

draw_line_h:
	;start_x, start_y, end_x, color
	push bx
	mov bx, sp
	draw_line_h_loop:
		inc word [bx + 10]
		push bx
		push word [bx + 10]
		push word [bx + 8]
		push word [bx + 4]
		call draw_point
		pop ax
		pop ax
		pop ax
		pop bx
		mov ax, [bx + 6]
		cmp ax, [bx + 10]
		je draw_line_h_finished
		jmp draw_line_h_loop
	draw_line_h_finished:
		pop bx
		ret

draw_square:
	;start_x, start_y, end_x, end_y, color
	mov bx, sp
	
	push word [bx + 10]
	push word [bx + 8]
	push word [bx + 4]
	push word [bx + 2]
	call draw_line_v

	push word [bx + 6]
	push word [bx + 8]
	push word [bx + 4]
	push word [bx + 2]
	call draw_line_v

	push word [bx + 10]
	push word [bx + 8]
	push word [bx + 6]
	push word [bx + 2]
	call draw_line_h

	push word [bx + 10]
	push word [bx + 4]
	push word [bx + 6]
	push word [bx + 2]
	call draw_line_h

	mov sp, bx
	ret

print_char:
	push bx
	mov bx, sp
	mov ax, [bx + 4]
	mov bl, 3
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

move_cursor:
	;row(y), column(x)
	mov bx, sp
	mov ah, 0x2
	mov dl, [bx + 2]
	mov dh, [bx + 4]
	mov bx, 0
	int 0x10
	ret
