
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

$(ROOT_PATH)/tools/dfu-util:
	cd $(ROOT_PATH)/tools ; git clone https://git.gitorious.org/dfu-util/dfu-util.git

