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