ENTRY(_start)

MEMORY {
	BOOT0(RWX): ORIGIN = 0x7c00, LENGTH = 0x200
	BOOT(RWX): ORIGIN = 0x7e00, LENGTH = 0x800
	KERNEL_DATA(R): ORIGIN = 0xae00, LENGTH = 0x2800
	KERNEL_CODE(RWX): ORIGIN = 0x8600, LENGTH = 0x2800
	KERNEL_BSS(RW): ORIGIN = 0x15000, LENGTH = 0x1400
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

	.kernel_data :
	{
		*(.data)
	} > KERNEL_DATA

	.kernel_code : 
	{
		*(.text)
	} > KERNEL_CODE

	.kernel_bss :
	{
		*(.bss)
	} > KERNEL_BSS
}
