ENTRY(_start)

MEMORY {
	BOOT0(RWX): ORIGIN = 0x7c00, LENGTH = 0x200
	BOOT(RWX): ORIGIN = 0x7e00, LENGTH = 0xA00
	KERNEL_DATA(R): ORIGIN = 0x8800, LENGTH = 0x2800
	KERNEL_CODE(RWX): ORIGIN = 0xb000, LENGTH = 0x2800
	KERNEL_BSS(RW): ORIGIN = 0xD800, LENGTH = 0x1400
}

SECTIONS {
	.boot0 :
	{
		*(.boot0_code)
	} > BOOT0

	.boot :
	{
		*(.boot_code)
		*(.boot_lib)
		*(.boot_data)
	} > BOOT

	.boot_fill :
	{
		FILL(0x00);
		. = ORIGIN(BOOT) + LENGTH(BOOT) - 1;
		BYTE(0xaa);
	} > BOOT

	.kernel_data :
	{
		*(.data)

	} > KERNEL_DATA

	.kernel_data_fill :
	{
		FILL(0x0);
		. = ORIGIN(KERNEL_DATA) + LENGTH(KERNEL_DATA) - 1;
		BYTE(0xaa);
	} > KERNEL_DATA

	.kernel_code : 
	{
		*(.kernel_load)
		*(.text)
	} > KERNEL_CODE

	.kernel_code_fill :
	{
		FILL(0x0);
		. = ORIGIN(KERNEL_CODE) + LENGTH(KERNEL_CODE) - 1;
		BYTE(0xaa);
	} > KERNEL_CODE

	.kernel_bss :
	{
		*(.bss)
	} > KERNEL_BSS
}
