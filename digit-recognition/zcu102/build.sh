#!/bin/bash
cd ../../
root_dir=$(pwd)
cd -


export PLATFORM_REPO_PATHS=${root_dir}/platform/embedded_platform/zcu102_custom
export ROOTFS=${root_dir}/platform/embedded_platform/linux
#export MaxJobNum=$(nproc)
export MaxJobNum=10
source ${root_dir}/platform/embedded_platform/sdkdir/environment-setup-aarch64-xilinx-linux
#source /opt/Xilinx/Vitis/2020.2/settings64.sh
source /scratch/unsafe/Xilinx/Vitis/2020.2/settings64.sh

export kl_name=DigitRec

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


