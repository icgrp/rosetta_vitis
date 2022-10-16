#!/bin/bash
cd ../../
root_dir=$(pwd)
cd -

# added by dopark
export PLATFORM_REPO_PATHS=/opt/platforms/xilinx_zcu102_base_202110_1
export ROOTFS=/opt/platforms/xilinx-zynqmp-common-v2021.1
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
unset LD_LIBRARY_PATH
source /opt/platforms/xilinx-zynqmp-common-v2021.1/ir/environment-setup-cortexa72-cortexa53-xilinx-linux
export kl_name=spam_filter
export MaxJobNum=$(nproc)

# export PLATFORM_REPO_PATHS=${root_dir}/platform/embedded_platform/zcu102_custom
# export ROOTFS=${root_dir}/platform/embedded_platform/linux
# #export MaxJobNum=$(nproc)
# export MaxJobNum=10
# source ${root_dir}/platform/embedded_platform/sdkdir/environment-setup-aarch64-xilinx-linux
# #source /opt/Xilinx/Vitis/2020.2/settings64.sh
# source /scratch/unsafe/Xilinx/Vitis/2020.2/settings64.sh

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


