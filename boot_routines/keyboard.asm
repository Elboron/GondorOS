[bits 16]

wait_read_input:
	;Return is moved into eax by BIOS
	;AH->keyboard scan code, AL->ASCII
	mov ah, 0x0
	int 0x16
	ret
