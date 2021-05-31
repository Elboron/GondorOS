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
	tmp.segment_selector |= (segment_index << 3) & 0b000;
	return tmp;
}

void	add_descriptor (int index, struct IDT_P_Descriptor descriptor) {
	interrupt_descriptor_table[index] = descriptor;
	++IDT_P_entry_count;
}

void	load_idt () {

}

