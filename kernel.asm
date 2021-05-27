[bits 32]

section .text
mov eax, 0xb8000
mov byte [eax], 'G'
mov byte [eax + 1], 0b00000101
mov byte [eax + 2], 'G'
mov byte [eax + 3], 0b00000101
xchg bx, bx
jmp $
times 10240 - ($ - $$) db 0

section .data
times 10240 - ($ - $$) db 0
