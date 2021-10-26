[bits 32]

extern kernel_main

section .kernel_load
load_kernel:
call kernel_main
mov edx, 0
mov eax, 0x8
mov ecx, 0x0
div ecx
xchg bx, bx
jmp $

section .data
