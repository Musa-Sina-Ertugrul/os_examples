#include "idt.h"
#include <idt.h>
#include <stdint.h>

void set_idt_entry(int i,uint32_t handler){
    idt[i].offset_1 = handler & 0x0000FFFF;
    idt[i].offset_2 = handler & 0xFFFF0000;
    idt[i].zero = 0;
    idt[i].selector = KERNEL_CS;
    idt[i].type_attributes = 0x8e;
}

void set_idtr(){
    idtr->base = &idt;
    idtr->limit = 256 * sizeof(struct interrupt_descriptor_table) -1;
    __asm__ __volatile__("lidt (%0)"::"r"(idtr));
}