section .text
mov ah, 0xe
mov al, 'G'
mov bh, 0
mov bl, 3
int 0x10
times 10240 - ($ - $$) db 0

section .data
times 10240 - ($ - $$) db 0
