[bits 32]

extern kernel_main

section .kernel_load
load_kernel:
call kernel_main
jmp $

section .data
