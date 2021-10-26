#include "kernel/framebuffer/write.h"
#include "kernel/interrupts/idt_protected.h"

void idt_test () {
	FRA_write("Divide error.");
}

void of_test () {
	FRA_write("Overflow.");
}

void gp_fault () {
	FRA_write("General protection fault.");
}

void kernel_main(void) {
	extern void load_gdt(void);

	const char boot_string[] = "Hello World!\nFOR GONDOR!\n\0";

	struct IDT_P_Descriptor divide_error = create_descriptor((int*)idt_test, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor debug_exc = create_descriptor((int*)0, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor nmi = create_descriptor((int*)0, 1, INTERRUPT_GATE, 0, 1);
	struct IDT_P_Descriptor breakpoint_exc = create_descriptor((int*)of_test, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor general_protection = create_descriptor((int*)gp_fault, 1, TRAP_GATE, 0, 1);

	add_descriptor(0, divide_error);
	add_descriptor(1, debug_exc);
	add_descriptor(2, nmi);
	add_descriptor(3, breakpoint_exc);
	add_descriptor(13, general_protection);
	
	load_idt();

    	/* Clears the screen. */
    	FRA_new_page();
    	FRA_set_color(Black, White);
    	FRA_write(boot_string);
    	FRA_fill(Cyan);
    	FRA_set_color(Magenta, Red);
	return;
}
