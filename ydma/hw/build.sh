#!/bin/bash

# Exit when any command fails
set -e
export MaxJobNum=$(nproc)
source /scratch/unsafe/Xilinx/Vitis/2022.1/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/scratch/unsafe/Xilinx/platforms/xilinx_u50_gen3x16_xdma_5_202210_1
# Make sure everything is up to date
make all 

