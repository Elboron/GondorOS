#include "kernel/framebuffer/write.h"

void kernel_main(void) {
	extern void load_gdt(void);

	const char boot_string[] = "Hello World!\nFOR GONDOR!\n\0";

    	/* Clears the screen. */
    	FRA_new_page();
    	FRA_set_color(Black, White);
    	FRA_write(boot_string);
    	FRA_fill(Cyan);
    	FRA_set_color(Magenta, Red);
}
