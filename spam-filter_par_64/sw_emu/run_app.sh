#
# In QEMU, once Linux has booted, run this script by entering the following command:
#

export XCL_EMULATION_MODE=sw_emu
./app.exe spam_filter.xclbin

echo "INFO: press Ctrl+a x to exit qemu"