#ifndef IDT_PROTECTED
#define IDT_PROTECTED

#include "../framebuffer/write.h"

extern struct IDT_P_Descriptor* interrupt_descriptor_table;

extern int IDT_P_entry_count;

struct __attribute__((__packed__)) IDT_P_Descriptor {
	/* Offset Bit 0 - 15 */
	unsigned int offset : 16; 	
	unsigned int segment_selector : 16; 
	unsigned int reserved : 8;
	/* D: 0 = 16bit/1 = 32bit */
	/* Trap: 0D111 Interrupt: 0D110 Task: 00101 */
	unsigned int gate_type : 5;
	unsigned int dpl : 2;
	unsigned int segment_present : 1;
	/* Offset bit 16 - 31 */
	unsigned int offset_high : 16;
};

struct __attribute__((__packed__)) IDT_P_Descriptor_Layout {
	unsigned int size : 16;
	unsigned long start : 32;
};

enum IDT_P_Gate_Type {
	TRAP_GATE,
	INTERRUPT_GATE,
	TASK_GATE
};

struct IDT_P_Descriptor	create_descriptor (int* offset, int segment_index, enum IDT_P_Gate_Type gate_type, int dpl, int segment_present);

void	IDT_P_add_descriptor (int index, struct IDT_P_Descriptor descriptor);

void	IDT_P_increase_descriptor_count();

void	IDT_P_init_idt ();

void	IDT_P_load_idt ();

void	divide_error ();

void	default_exception ();

void	overflow_error ();

void	over_bound_range ();

void 	invalid_opcode ();

void	double_fault ();

void	segment_not_present();

void	stack_segment_fault ();

void	control_protection ();

void	print (char* error);

#endif
