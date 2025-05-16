PATH_i686 := /home/musasina/opt/cross/bin
CC := $(PATH_i686)/i686-elf-gcc
CFLAGS := -g -Wall -ffreestanding -O0 -nostdlib
ASM := nasm
ASM_FLAGS := -g
LD := $(PATH_i686)/i686-elf-ld
LD_FLAGS := --discard-none --nostdlib -g
BUILD_DIR := build
OBJ_DIR := build/lib
SRC_DIR := src
SRC_FILES_C := $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES_C := $(foreach word, $(SRC_FILES_C), $(patsubst %.c, %.o, $(patsubst src/%, %, $(word))))
SRC_FILES_ASM := $(wildcard $(SRC_DIR)/*.asm)
OBJ_KERNEL_ASM := kernel.asm.o
OBJ_FILES_ASM := $(foreach word, $(SRC_FILES_ASM), $(patsubst %, %.o, $(patsubst src/%, %, $(word))))
OBJ_FILES_ASM := $(filter-out $(OBJ_KERNEL_ASM),$(OBJ_FILES_ASM))
INCLUDE := include

all: build $(OBJ_KERNEL_ASM) $(OBJ_FILES_C) $(OBJ_FILES_ASM) nasm

.PHONY: build
build:
	mkdir -p $(OBJ_DIR)

nasm:
	$(ASM) $(ASM_FLAGS) -f bin $(SRC_DIR)/boot/boot.asm -o $(BUILD_DIR)/boot
	$(LD) $(LD_FLAGS) -o $(BUILD_DIR)/kernel -Tlinker.ld $(OBJ_DIR)/$(OBJ_KERNEL_ASM) $(foreach word , $(OBJ_FILES_ASM),$(OBJ_DIR)/$(word)) $(foreach word , $(OBJ_FILES_C),$(OBJ_DIR)/$(word))
	dd if=/dev/zero of=$(BUILD_DIR)/floppy bs=512 count=1
	cat $(BUILD_DIR)/kernel >> $(BUILD_DIR)/boot
	cat $(BUILD_DIR)/floppy >> $(BUILD_DIR)/boot

.PHONY: $(OBJ_FILES_ASM)
$(OBJ_FILES_ASM):
	$(ASM) $(ASM_FLAGS) -f elf $(SRC_DIR)/$(patsubst %.o,%,$@) -o $(OBJ_DIR)/$@

.PHONY: $(OBJ_KERNEL_ASM)
$(OBJ_KERNEL_ASM):
	$(ASM) $(ASM_FLAGS) -f elf $(SRC_DIR)/$(patsubst %.o,%,$@) -o $(OBJ_DIR)/$@

.PHONY: $(OBJ_FILES_C)
$(OBJ_FILES_C):

	$(CC) $(CFLAGS) -I$(INCLUDE) -c $(SRC_DIR)/$(patsubst %.o,%.c,$@) -o $(OBJ_DIR)/$@

dump:
	$(LD) $(LD_FLAGS) -o $(BUILD_DIR)/kernel_dump.o -Tlinker_obj.ld $(OBJ_DIR)/$(OBJ_KERNEL_ASM) $(foreach word , $(OBJ_FILES_ASM),$(OBJ_DIR)/$(word)) $(foreach word , $(OBJ_FILES_C),$(OBJ_DIR)/$(word))
run:
	sudo qemu-system-i386 -s -S -fda $(BUILD_DIR)/boot
clean:
	rm -rf ./build