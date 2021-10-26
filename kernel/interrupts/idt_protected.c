#include "idt_protected.h"

struct IDT_P_Descriptor* interrupt_descriptor_table = (struct IDT_P_Descriptor*) 0x100000;

int IDT_P_entry_count = 0;

struct IDT_P_Descriptor	create_descriptor (int* offset, int segment_index, enum IDT_P_Gate_Type gate_type, int dpl, int segment_present) {
	struct IDT_P_Descriptor tmp = {0};
	tmp.offset |= (int)(offset);
	tmp.offset_high |= ((int)offset >> 16);
	switch (gate_type) {
	case TRAP_GATE:
		tmp.gate_type |= 0b01111;
		break;
	case INTERRUPT_GATE:
		tmp.gate_type |= 0b01110;
		break;
	case TASK_GATE:
		tmp.gate_type |= 0b00101;
		break;
	}
	tmp.dpl |= dpl;
	tmp.segment_present |= segment_present;
	/* Leave DPL and RPL 0 */
	tmp.segment_selector |= 0x8;
	//tmp.segment_selector |= ((segment_index << 3) & 0b000);
	return tmp;
}

void	add_descriptor (int index, struct IDT_P_Descriptor descriptor) {
	interrupt_descriptor_table[index] = descriptor;
	++IDT_P_entry_count;
}

void	init_idt () {
	struct IDT_P_Descriptor de = create_descriptor((int*)divide_error, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor oe = create_descriptor((int*)overflow_error, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor obr = create_descriptor((int*)over_bound_range, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor io = create_descriptor((int*)invalid_opcode, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor df = create_descriptor((int*)double_fault, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor snp = create_descriptor((int*)segment_not_present, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor ssf = create_descriptor((int*)stack_segment_fault, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor cp = create_descriptor((int*)control_protection, 1, TRAP_GATE, 0, 1);
	struct IDT_P_Descriptor default_f = create_descriptor((int*)default_exception, 1, TRAP_GATE, 0, 1);

	add_descriptor(0, de);
	add_descriptor(1, default_f);
	increase_descriptor_count();
	add_descriptor(3, default_f);
	add_descriptor(4, oe);
	add_descriptor(5, obr);
	add_descriptor(6, io);
	add_descriptor(7, default_f);
	add_descriptor(8, df);
	add_descriptor(9, default_f);
	add_descriptor(10, default_f);
	add_descriptor(11, snp);
	add_descriptor(12, ssf);
	add_descriptor(13, cp);
	add_descriptor(14, default_f);
	increase_descriptor_count();
	add_descriptor(16, default_f);
	add_descriptor(17, default_f);
	add_descriptor(18, default_f);
	add_descriptor(19, default_f);
	add_descriptor(20, default_f);
	add_descriptor(21, default_f);
}

void	load_idt () {
	unsigned int idt_size = (unsigned int)IDT_P_entry_count * 8;
	unsigned long idt_start = 0x100000;
	volatile struct IDT_P_Descriptor_Layout layout = {0};
	layout.size = idt_size;
	layout.start = idt_start;
	int address = (int)&layout;
	asm("movl %0, %%eax\n\t"
		"lidt (%%eax)"
		:
		: "b" (address)
		: "eax"
	);
}

void	increase_descriptor_count () {
	++IDT_P_entry_count;
}

void	divide_error () {
	FRA_write("Error while division\n");
}

void	default_exception () {
	FRA_write("An unknown exception occurred\n");
}

void	overflow_error () {
	FRA_write("Overflow while performing INT 0\n");
}

void	over_bound_range () {
	FRA_write("BOUND range exceeded.\n");
}

void 	invalid_opcode () {
	FRA_write("Usage of invalid opcode\n");
}

void	double_fault () {
	FRA_write("Processor double-faulted while execution\n");
}

void	segment_not_present() {
	FRA_write("A non-existing segment was used\n");
}

void	stack_segment_fault () {
	FRA_write("Stack overflow, you moron\n");
}

void	control_protection () {
	FRA_write("Missing ENDBRANCH instruction\n");
}

