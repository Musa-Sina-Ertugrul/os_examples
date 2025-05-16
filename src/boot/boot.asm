[bits 16]
[org 0x7C00]

KERNEL_OFFSET equ 0x1000

mov bx, real_mode
call print

mov ebx , KERNEL_OFFSET
mov dh, 31
mov dl, 0x02

call load_drive

call install_gdt
xor eax,eax
mov ax, 1
mov cr0, eax

call CODE_SEG:BEGIN_PM
jmp $

load_drive:
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov cl, dl
    mov dh, 0x00
    mov dl, 0x00
    int 0x13
    ret

install_gdt:
    cli
    pusha
    lgdt [gdt_descriptor]
    popa
    ret

gdt_null:
    dd 0
    dd 0
gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_null - gdt_end - 1
    dd gdt_null

CODE_SEG equ 0x08
DATA_SEG equ 0x10

real_mode: db "Real Mode!",0

%include "src/boot/print.asm"

[bits 32]
BEGIN_PM:
    mov ax , DATA_SEG
    mov ds, ax
    mov es, ax
    mov gs , ax
    mov fs , ax
    mov ss ,ax

    mov ebp , 0x900000
    mov esp ,ebp

    call KERNEL_OFFSET
    jmp $


times 510 - ($-$$ ) db 0

dw 0xAA55