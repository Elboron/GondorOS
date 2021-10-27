
#include "kernel/framebuffer/write.h"
#include "kernel/interrupts/idt_protected.h"

void kernel_main(void) {
	extern void load_gdt(void);

	const char boot_string[] = "Hello World!\nFOR GONDOR!\n\0";
	
	IDT_P_init_idt();
	IDT_P_load_idt();

    	/* Clears the screen. */
    	FRA_new_page();
    	FRA_set_color(Black, White);
    	FRA_write(boot_string);
    	FRA_fill(Cyan);
    	FRA_set_color(Magenta, Red);
	return;
}

void after_print(void) {
	FRA_write("Hell this is working\n");
}
