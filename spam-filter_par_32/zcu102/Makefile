PRJ_NAME=spam_filter
SRC_DIR=../src
TARGET=hw

all: package/sd_card.img
# all: app.exe emconfig.json $(PRJ_NAME).xclbin

app.exe: $(SRC_DIR)/host.cpp
	${CXX} -Wall -g -std=c++11 $(SRC_DIR)/host.cpp -o app.exe \
		-I${XILINX_VIVADO}/include/ \
		-lOpenCL -lpthread -lrt -lstdc++
	
$(PRJ_NAME).xo: $(SRC_DIR)/$(PRJ_NAME).cpp
	v++ -c -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg --kernel_frequency 200 -k $(PRJ_NAME) \
		-I${XILINX_VIVADO}/include/ \
		-I$(SRC_DIR)/ $(SRC_DIR)/$(PRJ_NAME).cpp -o $(PRJ_NAME).xo 

$(PRJ_NAME).xclbin: ./$(PRJ_NAME).xo
	v++ -l -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg ./$(PRJ_NAME).xo \
		--clock.defaultFreqHz 200000000 \
		--vivado.synth.jobs $(MaxJobNum) \
		--vivado.impl.jobs $(MaxJobNum) \
		-o $(PRJ_NAME).xclbin

package/sd_card.img: app.exe $(PRJ_NAME).xclbin xrt.ini run_app.sh
	$(call ndef,ROOTFS)
	v++ -p -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg $(PRJ_NAME).xclbin \
		--package.out_dir package \
		--package.rootfs ${ROOTFS}/rootfs.ext4 \
		--package.sd_file $(PRJ_NAME).xclbin \
		--package.sd_file ${ROOTFS}/Image \
		--package.sd_file xrt.ini \
		--package.sd_file app.exe \
		--package.sd_file run_app.sh \
		--package.sd_file ../data

clean:
	rm -rf ./package $(PRJ_NAME)* *xclbin* app.exe *json *xo *csv *log *summary _x package *.json .run .Xil .ipcache *.jou

# Unless specified, use the current directory name as the v++ build target
# TARGET ?= $(notdir $(CURDIR))
