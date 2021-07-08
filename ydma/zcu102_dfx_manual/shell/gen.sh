bit_name=$1
xclbin_name=${bit_name%.bit}
#xclbin_name=${xclbin_name#./bitstream/}
xclbin_name=`echo $xclbin_name | sed 's/bitstream\///'`

echo ${bit_name}
echo ${xclbin_name}

xclbinutil \
--add-section DEBUG_IP_LAYOUT:JSON:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/debug_ip_layout.rtd \
--add-section BITSTREAM:RAW:${bit_name} \
--force \
--target hw \
--key-value SYS:dfx_enable:true \
--add-section :JSON:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/ydma.rtd \
--add-section CLOCK_FREQ_TOPOLOGY:JSON:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/ydma_xml.rtd \
--add-section BUILD_METADATA:JSON:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/ydma_build.rtd \
--add-section EMBEDDED_METADATA:RAW:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/ydma.xml \
--add-section SYSTEM_METADATA:RAW:/home/ylxiao/ws_202/rosetta_vitis/ydma/zcu102_dfx/_x/link/int/systemDiagramModelSlrBaseAddress.json \
--key-value SYS:PlatformVBNV:xilinx_zcu102_dynamic_1_0 \
--output xclbin/${xclbin_name}.xclbin

