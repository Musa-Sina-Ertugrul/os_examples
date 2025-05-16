#include "io.h"
#include <stdint.h>

uint8_t inb(uint16_t port){
    uint8_t result;
    __asm__ __volatile__ ("inb %%dx , %%al":"=a"(result):"d"(port));
    return result;
}
uint8_t inw(uint16_t port){
    uint16_t result;
    __asm__ __volatile__ ("inw %%dx , %%ax":"=a"(result):"d"(port));
    return result;
}
void outb(uint16_t port, uint8_t data){
    __asm__ __volatile__ ("outb %%al , %%dx"::"a"(data),"d"(port));
}
void outw(uint16_t port, uint16_t data){
    __asm__ __volatile__ ("outw %%ax , %%dx"::"a"(data),"d"(port));
}