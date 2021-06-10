#!/bin/bash

# Exit when any command fails
set -e
source /opt/Xilinx/Vitis/2020.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=xilinx_u250_gen3x16_xdma_3_1_202020_1
# Make sure everything is up to date
make all 

