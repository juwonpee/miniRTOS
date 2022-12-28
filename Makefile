ARCH = armv7-a
MCPU = cortex-a8

TARGET = rvpb

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-gcc
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./linker.ld
MAP_FILE = build/miniRTOS.map

ASM_SRCS = $(wildcard boot/$(TARGET)*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.os, $(ASM_SRCS))

VPATH = boot 			\
        hal/$(TARGET)	\
        lib

C_SRCS  = $(notdir $(wildcard boot/*.c))
C_SRCS += $(notdir $(wildcard hal/$(TARGET)/*.c))
C_SRCS += $(notdir $(wildcard lib/*.c))
C_OBJS = $(patsubst %.c, build/%.o, $(C_SRCS))

INC_DIRS  = -I include 			\
			-I include/$(TARGET)\
            -I hal	   			\
            -I hal/$(TARGET)	\
            -I lib

CFLAGS = -c -g -std=c11 -mthumb-interwork

LDFLAGS = -nostartfiles -nostdlib -nodefaultlibs -static -lgcc

miniRTOS = build/miniRTOS.axf
miniRTOS_bin = build/miniRTOS.bin

.PHONY: all clean run debug gdb

all: $(miniRTOS)

clean:
	@rm -fr build
	
run: $(miniRTOS)
	qemu-system-arm -M realview-pb-a8 -kernel $(miniRTOS) -nographic
	
debug: $(miniRTOS)
	qemu-system-arm -M realview-pb-a8 -kernel $(miniRTOS) -S -gdb tcp::1234,ipv4
	
gdb:
	arm-none-eabi-gdb

kill:
	kill -9 `ps aux | grep 'qemu' | awk 'NR==1{print $$2}'`
	
$(miniRTOS): $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(miniRTOS) $(ASM_OBJS) $(C_OBJS) -Wl,-Map=$(MAP_FILE) $(LDFLAGS)
	$(OC) -O binary $(miniRTOS) $(miniRTOS_bin)
	
build/%.os: %.S
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) -marm $(INC_DIRS) $(CFLAGS) -o $@ $<
	
build/%.o: %.c
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) -marm $(INC_DIRS) $(CFLAGS) -o $@ $<
