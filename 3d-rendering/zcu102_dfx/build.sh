#!/bin/bash
cd ../../
root_dir=$(pwd)
cd -


export PLATFORM_REPO_PATHS=/scratch/unsafe/Xilinx/platforms/xilinx_u50_gen3x16_xdma_5_202210_1
export ROOTFS=/scratch/unsafe/Xilinx/xilinx-zynqmp-common-v2022.1
export kl_name=rendering
export MaxJobNum=$(nproc)
#export MaxJobNum=10

source /opt/Xilinx/Vitis/2020.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
unset LD_LIBRARY_PATH

source /scratch/unsafe/Xilinx/xilinx-zynqmp-common-v2022.1/sdk/environment-setup-cortexa72-cortexa53-xilinx-linux

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


