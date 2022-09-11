#!/bin/bash


# Exit when any command fails
set -e
source /scratch/unsafe/Xilinx/Vitis/2022.1/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/scratch/unsafe/Xilinx/platforms/xilinx_u50_gen3x16_xdma_5_202210_1
kenerl_name=ydma
# Make sure everything is up to date
make all 

# Run the application in HW emulation mode
XCL_EMULATION_MODE=sw_emu ./app.exe ${kenerl_name}.xclbin 

