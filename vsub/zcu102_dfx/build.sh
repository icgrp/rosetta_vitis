#!/bin/bash
cd ../../
root_dir=$(pwd)
cd -


export PLATFORM_REPO_PATHS=/home/ylxiao/workspace/Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/xilinx_zcu102_base_dfx/platform_repo/xilinx_zcu102_base_dfx_202020_1/export/xilinx_zcu102_base_dfx_202020_1
export ROOTFS=/home/ylxiao/workspace/Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/xilinx_zcu102_base_dfx/sw/build/images/linux
export kl_name=vadd
export MaxJobNum=$(nproc)
#export MaxJobNum=10

source /opt/Xilinx/Vitis/2020.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
unset LD_LIBRARY_PATH

source /home/ylxiao/workspace/Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/xilinx_zcu102_base_dfx/sw/build/sdkdir/environment-setup-aarch64-xilinx-linux

# Make sure everything is up to date
make all 



# Exit when any command fails
#set -e
#if [[ -z "$ROOTFS" ]]; then
#   echo "Error: make sure to set the ROOTFS environment variable"
#   exit
#fi
#if [[ -z "$SYSROOT" ]]; then
#   echo "Error: make sure to set the SYSROOT environment variable"
#   exit
#fi
#if [[ -z "$PLATFORM_REPO_PATHS" ]]; then
#   echo "Error: make sure to set the PLATFORM_REPO_PATHS environment variable"
#   exit
#fi


