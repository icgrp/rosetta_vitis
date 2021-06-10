#!/bin/bash
cd ../../
root_dir=$(pwd)
cd -


export PLATFORM_REPO_PATHS=/home/ylxiao/peta_202/zcu102_custom_pkg/zcu102_custom/export/zcu102_custom
export ROOTFS=/home/ylxiao/peta_202/zcu102_custom_plnx/images/linux
export kl_name=vadd
export MaxJobNum=$(nproc)
#export MaxJobNum=10
source /home/ylxiao/peta_202/zcu102_custom_pkg/environment-setup-aarch64-xilinx-linux
source /opt/Xilinx/Vitis/2020.2/settings64.sh
#source /scratch/unsafe/Xilinx/Vitis/2020.2/settings64.sh

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


