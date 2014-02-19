
ifndef ROOT_PATH
	ROOT_PATH = dennao/
endif

LIB_CPP_SRC= $(ROOT_PATH)/usb/usb_inst.cpp \
	$(ROOT_PATH)/usb/usb_flightsim.cpp \
	$(ROOT_PATH)/main.cpp \
	$(ROOT_PATH)/arduino/Print.cpp \
	$(ROOT_PATH)/arduino/HardwareSerial2.cpp \
	$(ROOT_PATH)/arduino/IPAddress.cpp \
	$(ROOT_PATH)/arduino/Stream.cpp \
	$(ROOT_PATH)/arduino/IntervalTimer.cpp \
	$(ROOT_PATH)/arduino/new.cpp \
	$(ROOT_PATH)/arduino/HardwareSerial1.cpp \
	$(ROOT_PATH)/arduino/WMath.cpp \
	$(ROOT_PATH)/arduino/AudioStream.cpp \
	$(ROOT_PATH)/arduino/WString.cpp \
	$(ROOT_PATH)/arduino/Tone.cpp \
	$(ROOT_PATH)/arduino/avr_emulation.cpp \
	$(ROOT_PATH)/arduino/HardwareSerial3.cpp

LIB_C_SRC = $(ROOT_PATH)/usb/usb_dennao.c \
	$(ROOT_PATH)/usb/usb_dev.c \
	$(ROOT_PATH)/usb/usb_keyboard.c \
	$(ROOT_PATH)/usb/usb_mem.c \
	$(ROOT_PATH)/usb/usb_midi.c \
	$(ROOT_PATH)/usb/usb_seremu.c \
	$(ROOT_PATH)/usb/usb_rawhid.c \
	$(ROOT_PATH)/usb/usb_joystick.c \
	$(ROOT_PATH)/usb/usb_desc.c \
	$(ROOT_PATH)/usb/usb_serial.c \
	$(ROOT_PATH)/usb/usb_mouse.c \
	$(ROOT_PATH)/arduino/serial3.c \
	$(ROOT_PATH)/arduino/mk20dx128.c \
	$(ROOT_PATH)/arduino/analog.c \
	$(ROOT_PATH)/arduino/eeprom.c \
	$(ROOT_PATH)/arduino/serial1.c \
	$(ROOT_PATH)/arduino/keylayouts.c \
	$(ROOT_PATH)/arduino/touch.c \
	$(ROOT_PATH)/arduino/nonstd.c \
	$(ROOT_PATH)/arduino/yield.c \
	$(ROOT_PATH)/arduino/serial2.c \
	$(ROOT_PATH)/arduino/pins_teensy.c \
	$(ROOT_PATH)/arduino/math_helper.c

TARGET = main

LIB_SRCS = $(LIB_CPP_SRC) $(LIB_C_SRC)
APP_SRCS = $(APP_CPP_SRC) $(APP_C_SRC)
LIB_OBJS = $(patsubst %.cpp,%.o,$(LIB_CPP_SRC)) $(patsubst %.c,%.o,$(LIB_C_SRC))
APP_OBJS = $(patsubst %.cpp,%.o,$(APP_CPP_SRC)) $(patsubst %.c,%.o,$(APP_C_SRC))
OBJS = $(APP_OBJS) $(LIB_OBJS)

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

# CPPFLAGS = compiler options for C and C++
CPPFLAGS = -Wall -g -Os -mcpu=cortex-m4 -mthumb -nostdlib -MMD $(OPTIONS) -I$(ROOT_PATH)/include -I./ \
	-DF_CPU=$(F_CPU) -D__MK20DX128__ -DTEENSYDUINO=117 -DLAYOUT_US_INTERNATIONAL -DUSB_DENNAO -DARDUINO \
	-fshort-wchar

# compiler options for C++ only
CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti

# compiler options for C only
CFLAGS =

# linker options
LDFLAGS = -Os -Wl,--gc-sections -mcpu=cortex-m4 -mthumb -T$(ROOT_PATH)/$(PLATFORM).ld

# additional libraries to link
LIBS = -lm

.PHONY:	clean program toolchain

all: $(TARGET).hex

# compiler generated dependency info
-include $(OBJS:.o=.d)

%.elf: $(OBJS) $(ROOT_PATH)/$(PLATFORM).ld toolchain
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

%.hex: %.elf toolchain
	$(SIZE) $<
	$(OBJCOPY) -O ihex -R .eeprom $< $@

%.dump: %.out toolchain
	$(OBJDUMP) --disassemble $< >$@

%.srec: %.out toolchain
	$(OBJCOPY) -O srec $< $@

%.out: $(APP_OBJS) $(ROOT_PATH)/$(PLATFORM).ld libusbstack.a toolchain
	$(CC) $(ALL_LD_FLAGS) -T $(ROOT_PATH)/$(PLATFORM).ld -o $@ $(APP_OBJS) libusbstack.a

libdennao.a: $(LIB_OBJS) toolchain
	$(AR) -rv $@ $(LIB_OBJS)

clean:
	-rm -rf $(LIB_OBJS) $(APP_OBJS) $(TARGET).hex $(TARGET).dump $(TARGET).out $(TARGET).srec $(TARGET).elf $(OBJS:.o=.d)

program: $(TARGET).hex $(ROOT_PATH)/tools/teensy_loader_cli/teensy_loader_cli
	$(ROOT_PATH)/tools/teensy_loader_cli/teensy_loader_cli -mmcu=$(PLATFORM) $< -w -v

TEENSY_LOADER_DOWNLOAD_PATH=http://www.pjrc.com/teensy/teensy_loader_cli.2.1.zip
$(ROOT_PATH)/tools/teensy_loader_cli: 
	wget $(TEENSY_LOADER_DOWNLOAD_PATH) -O $(ROOT_PATH)/tools/teensy_loader.zip
	cd $(ROOT_PATH)/tools; unzip teensy_loader.zip

$(ROOT_PATH)/tools/teensy_loader_cli/teensy_loader_cli: $(ROOT_PATH)/tools/teensy_loader_cli
	make -C $(ROOT_PATH)/tools/teensy_loader_cli

DLPATH=https://launchpad.net/gcc-arm-embedded/4.7/4.7-2013-q2-update/+download/gcc-arm-none-eabi-4_7-2013q2-20130614

ifeq ($(shell uname -s), Darwin)
	DL_CMD=curl --location $(DLPATH)-mac.tar.bz2
else
	DL_CMD=wget --verbose $(DLPATH)-linux.tar.bz2 -O -
endif

toolchain: $(ROOT_PATH)/tools/gcc-arm/

$(ROOT_PATH)/tools/gcc-arm/:
	$(DL_CMD) | tar jxC $(ROOT_PATH)/tools/
	cd $(ROOT_PATH)/tools ;ln -s `ls -Artd gcc-arm-none-eabi* | tail -n 1` gcc-arm
