PRJ_NAME=optical_flow
SRC_DIR=../src
#img_src=$(basename $(notdir $(wildcard $(SRC_DIR)/imageLib/*.cpp)))
img_name=$(basename $(wildcard $(SRC_DIR)/imageLib/*.cpp))
img_obj=$(addsuffix .o, $(img_name))
#img_src=$(wildcard $(SRC_DIR)/imageLib/*.cpp)
TARGET=sw_emu

all: package/sd_card.img
# all: app.exe emconfig.json $(PRJ_NAME).xclbin

app.exe: $(SRC_DIR)/host.cpp $(img_obj)
	${CXX} -Wall -g -std=c++11 $(SRC_DIR)/host.cpp $(img_obj) -o app.exe \
		-I${XILINX_VIVADO}/include/ \
		-lOpenCL -lpthread -lrt -lstdc++

$(img_obj):$(SRC_DIR)/%.o:$(SRC_DIR)/%.cpp 
	${CXX} -Wall -g -std=c++11 -c $^ -o $@

$(PRJ_NAME).xo: $(SRC_DIR)/$(PRJ_NAME).cpp
	v++ -c -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg -k $(PRJ_NAME) \
		-I${XILINX_VIVADO}/include/ \
		-I$(SRC_DIR)/ $(SRC_DIR)/$(PRJ_NAME).cpp -o $(PRJ_NAME).xo 

$(PRJ_NAME).xclbin: ./$(PRJ_NAME).xo
	v++ -l -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg ./$(PRJ_NAME).xo -o $(PRJ_NAME).xclbin

package/sd_card.img: app.exe emconfig.json $(PRJ_NAME).xclbin xrt.ini run_app.sh
	v++ -p -t ${TARGET} --config $(SRC_DIR)/zcu102.cfg $(PRJ_NAME).xclbin \
		--package.out_dir package \
		--package.rootfs ${ROOTFS}/rootfs.ext4 \
		--package.sd_file $(PRJ_NAME).xclbin \
		--package.sd_file ${ROOTFS}/Image \
		--package.sd_file ../datasets/current \
		--package.sd_file xrt.ini \
		--package.sd_file emconfig.json \
		--package.sd_file app.exe \
		--package.sd_file run_app.sh

emconfig.json:
	emconfigutil --platform xilinx_zcu102_base_202110_1 --nd 1

clean:
	rm -rf ./package *.xclbin $(PRJ_NAME)* app.exe *json *csv *log *summary _x xilinx* .run .Xil .ipcache *.jou
	rm -rf $(SRC_DIR)/imageLib/*.o

# Unless specified, use the current directory name as the v++ build target
TARGET ?= $(notdir $(CURDIR))
