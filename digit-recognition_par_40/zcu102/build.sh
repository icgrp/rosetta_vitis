#!/bin/bash

# added by dopark
export PLATFORM_REPO_PATHS=/opt/platforms/xilinx_zcu102_base_202110_1
export ROOTFS=/opt/platforms/xilinx-zynqmp-common-v2021.1
unset LD_LIBRARY_PATH
source /opt/platforms/xilinx-zynqmp-common-v2021.1/ir/environment-setup-cortexa72-cortexa53-xilinx-linux
export kl_name=DigitRec
export MaxJobNum=$(nproc)


# Make sure everything is up to date
make all 