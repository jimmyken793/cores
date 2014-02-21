
ifndef ROOT_PATH
	ROOT_PATH = dennao/
endif

include $(ROOT_PATH)/source_list.mk

ifndef TARGET
	TARGET = main
endif

LIB_SRCS = $(LIB_CPP_SRC) $(LIB_C_SRC)
APP_SRCS = $(APP_CPP_SRC) $(APP_C_SRC)
LIB_OBJS = $(patsubst %.cpp,%.o,$(LIB_CPP_SRC)) $(patsubst %.c,%.o,$(LIB_C_SRC))
APP_OBJS = $(patsubst %.cpp,%.o,$(APP_CPP_SRC)) $(patsubst %.c,%.o,$(APP_C_SRC))
OBJS = $(LIB_OBJS) $(APP_OBJS)

GCC_ARM_VERSION := $(shell arm-none-eabi-gcc --version 2>/dev/null)
ifdef GCC_ARM_VERSION
	GCCDIR=
else
	GCCDIR=$(ROOT_PATH)/tools/gcc-arm/bin/
endif

ifndef PLATFORM
	PLATFORM = mk20dx128
endif

F_CPU=48000000

# names for the compiler programs
CC = $(GCCDIR)arm-none-eabi-gcc
CXX = $(GCCDIR)arm-none-eabi-g++
OBJCOPY = $(GCCDIR)arm-none-eabi-objcopy
SIZE = $(GCCDIR)arm-none-eabi-size
AR = $(GCCDIR)arm-none-eabi-ar
OBJDUMP = $(GCCDIR)arm-none-eabi-objdump
DFU_UTIL = dfu-util
DFU_SUFFIX = dfu-suffix

# CPPFLAGS = compiler options for C and C++
CPPFLAGS = -Wall -g -Os -mcpu=cortex-m4 -mthumb -nostdlib -MMD $(OPTIONS) -I$(ROOT_PATH)/include -I./ \
	-DF_CPU=$(F_CPU) -D__MK20DX128__ -DTEENSYDUINO=117 -DLAYOUT_US_INTERNATIONAL -DUSB_DENNAO -DARDUINO \
	-fshort-wchar 

# compiler options for C++ only
CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti

# compiler options for C only
CFLAGS =

# linker options
LDFLAGS = -Os -Wl,--gc-sections -mcpu=cortex-m4 -mthumb -T $(ROOT_PATH)/$(PLATFORM).ld

# additional libraries to link
LIBS = -lm

.PHONY:	clean teensy toolchain deploy dfu

all: $(TARGET).hex $(TARGET).srec

# compiler generated dependency info
-include $(OBJS:.o=.d)

%.elf: $(OBJS) $(ROOT_PATH)/$(PLATFORM).ld toolchain
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

%.hex: %.elf toolchain
	$(SIZE) $<
	$(OBJCOPY) -O ihex $< tmp.hex
	(grep -v :00000001FF tmp.hex; cat $(ROOT_PATH)/../bootloader/fc-boot.hex) > $@
	rm tmp.hex

%.dfu: %.elf
	$(OBJCOPY) -O binary $< $@
	$(DFU_SUFFIX) -a $@

%.dump: %.elf toolchain
	$(OBJDUMP) --disassemble $< >$@

%.bin: %.elf toolchain
	$(OBJCOPY) -O binary $< $@

%.srec: %.elf toolchain
	$(OBJCOPY) -O srec $< $@

DEPLOY_VOLUME = $(shell df -h 2>/dev/null | fgrep " 128M" | awk '{print $$6}')
deploy: $(TARGET).srec
	dd conv=fsync bs=64k if=$< of=$(DEPLOY_VOLUME)/$<
	cat $(DEPLOY_VOLUME)/LASTSTAT.TXT

dfu: $(TARGET).dfu
	$(DFU_UTIL) -D $<

clean:
	-rm -rf $(LIB_OBJS) $(APP_OBJS) $(TARGET).hex $(TARGET).dump $(TARGET).out $(TARGET).srec $(TARGET).elf $(OBJS:.o=.d) $(TARGET).dfu

teensy: $(TARGET).hex $(ROOT_PATH)/tools/teensy_loader_cli/teensy_loader_cli
	$(ROOT_PATH)/tools/teensy_loader_cli/teensy_loader_cli -mmcu=$(PLATFORM) $< -w -v

include $(ROOT_PATH)/toolkit.mk