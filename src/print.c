#include "print.h"
#include "io.h"
#include <stdint.h>
unsigned int get_col(unsigned int offset){
    return offset % (2 * VIDEO_TEXT_COL);
}
unsigned int get_row(unsigned int offset){
    return offset / (2 * VIDEO_TEXT_COL);
}
unsigned int get_offset(unsigned int row, unsigned int col){
    return (2*VIDEO_TEXT_COL*row) + 2*col;
}
unsigned int get_cursor_offset(){
    unsigned int pos = 0;
    outb(0x3d4,0x0E);
    pos = inb(0x3d5);
    pos = pos << 8;
    outb(0x3d4,0x0F);
    pos += inb(0x3d5);
    return 2 * pos;
}
void set_cursor_offset(unsigned int offset){
    offset /= 2;
    outb(0x3d4,0x0f);
    outb(0x3d5,(uint8_t)(offset & 0xff));
    outb(0x3d4,0x0E);
    outb(0x3d5,(uint8_t)((offset>>8) & 0xff));
}

void print_char(const char c){
    uint8_t* text_addr = (uint8_t*) VIDEO_TEXT_ADRESS;
    unsigned int offset = get_cursor_offset();
    if (c == '\n'){
        unsigned int row = get_row(offset);
        unsigned int col = get_col(offset);
        row++;
        offset = get_offset(row,0);
        set_cursor_offset(offset);
        return;
    }
    text_addr[offset] = c;
    text_addr[offset+1] = 0x0A;
    set_cursor_offset(offset+2);
}

void clear_screen(){
    set_cursor_offset(0);
    int offset = get_cursor_offset();
    for(int i = 0; i < VIDEO_TEXT_ROW; i++){
        for(int j = 0; j< VIDEO_TEXT_COL; j++){
            print_char(0);
        }
    }
    set_cursor_offset(0);
}