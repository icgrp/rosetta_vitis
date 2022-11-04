#!/bin/bash

# Exit when any command fails
set -e
source /scratch/unsafe/Xilinx/Vitis/2022.1/settings64.sh
source /opt/xilinx/xrt/setup.sh

# Make sure everything is up to date
make ACCEL=MONO app.exe
