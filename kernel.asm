[bits 32]

section .text
mov eax, 0xb8000
mov byte [eax + 10], 'G'
mov byte [eax + 11], 0x3
times 10240 - ($ - $$) db 0

section .data
times 10240 - ($ - $$) db 0
