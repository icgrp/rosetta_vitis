#!/bin/bash

# Exit when any command fails
set -e

# Make sure everything is up to date
make all 

# Run the application in HW emulation mode
export CRAFT_BNN_ROOT=../
XCL_EMULATION_MODE=sw_emu ./host.exe 

