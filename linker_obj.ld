ENTRY(main)
OUTPUT_FORMAT(elf32-i386)
SECTIONS
{
    . =  0x1000;
    .text ALIGN(4096): {
        *(.text)
        *(.text.)*
    }
    .rodata ALIGN(4096): {
        *(.rodata)
        *(.rodata.)*
    }
    .data ALIGN(4096): {
        *(.data)
        *(.data.)*
    }
    .bss ALIGN(4096): {
        *(.bss)
        *(.bss.)*
        *(COMMON)
    }
    .asm ALIGN(4096): {
        *(.asm)
        *(.asm.)*
    }
}