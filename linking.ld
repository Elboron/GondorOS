ENTRY(_start)

MEMORY {
	BOOT0(RWX): ORIGIN = 0x7c00, LENGTH = 0x200
	BOOT(RWX): ORIGIN = 0x7e00, LENGTH = 0x3c00
}

SECTIONS {
	.boot0 :
	{
		*(.boot0_code)
	} > BOOT0

	.boot :
	{
		*(.boot_code)
		*(.boot_data)	
	} > BOOT
}
