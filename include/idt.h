#ifndef __IDT_H__
#define __IDT_H__

#include <stdint.h>

#define KERNEL_CS 0x08

struct interrupt_descriptor_table{
    uint16_t offset_1;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attributes;
    uint16_t offset_2;
} __attribute__((packed));

struct interrupt_descriptor_table idt[256];

struct idt_descriptor
{
    uint16_t limit;
    uint32_t base;
}__attribute__((packed));

struct idt_descriptor* idtr;

void set_idt_entry(int i,uint32_t handler);
void set_idtr();

#endif