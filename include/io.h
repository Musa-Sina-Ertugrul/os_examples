#ifndef __IO_H__
#define __IO_H__

#include <stdint.h>

uint8_t inb(uint16_t port);
uint8_t inw(uint16_t port);
void outb(uint16_t port, uint8_t data);
void outw(uint16_t port, uint16_t data);


#endif