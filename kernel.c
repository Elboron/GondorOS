#include "kernel/framebuffer/write.h"
#include "kernel/interrupts/idt_protected.h"

void idt_test () {
	FRA_write("Divide error.");
}

void kernel_main(void) {
	extern void load_gdt(void);

	const char boot_string[] = "Hello World!\nFOR GONDOR!\n\0";

	struct IDT_P_Descriptor divide_error = create_descriptor((int*)idt_test, 0, TRAP_GATE, 0, 1);

	add_descriptor(0, divide_error);

	load_idt();

    	/* Clears the screen. */
    	FRA_new_page();
    	FRA_set_color(Black, White);
    	FRA_write(boot_string);
    	FRA_fill(Cyan);
    	FRA_set_color(Magenta, Red);
	return;
}
