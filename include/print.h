#ifndef __PRINT_H__
#define __PRINT_H__

#include <stdint.h>

#define VIDEO_TEXT_ADRESS 0xb8000
#define VIDEO_TEXT_COL 80
#define VIDEO_TEXT_ROW 25

void print(const char* str);
void print_at(const char* str , unsigned int row, unsigned int col);
void clear_screen();

#endif