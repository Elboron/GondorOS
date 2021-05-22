bits 16]
setup_print:
	mov al, 0x02
	mov ah, 0x0
	int 0x10
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
