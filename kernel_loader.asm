[bits 32]

extern kernel_main

section .kernel_load
load_kernel:
call kernel_main
xor eax, eax
xchg bx, bx
div al
xchg bx, bx
jmp $

section .data
