set part xczu9eg-ffvb1156-2-e
create_project -in_memory -part $part

add_files -quiet ./checkpoint/hw_bb_locked_locked.dcp
add_files -quiet ./checkpoint/page2.dcp
add_files -quiet ./checkpoint/page3.dcp
add_files -quiet ./checkpoint/page4.dcp
add_files -quiet ./checkpoint/page5.dcp
add_files -quiet ./checkpoint/page.dcp
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page2_inst} [get_files ./checkpoint/page2.dcp]
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page3_inst} [get_files ./checkpoint/page3.dcp]
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page4_inst} [get_files ./checkpoint/page4.dcp]
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page5_inst} [get_files ./checkpoint/page5.dcp]
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} [get_files ./checkpoint/page.dcp]


link_design -mode default -reconfig_partitions {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} -part xczu9eg-ffvb1156-2-e -top pfm_top_wrapper
opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force ./checkpoint/hw_bb_routed_routed.dcp
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page2_inst -force ./bitstream/page2_slow.bit
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page3_inst -force ./bitstream/page3_slow.bit
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page4_inst -force ./bitstream/page4_slow.bit
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page5_inst -force ./bitstream/page5_slow.bit
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page6_inst -force ./bitstream/page6_slow.bit


pr_recombine -cell pfm_top_i/dynamic_region
write_bitstream -force -cell pfm_top_i/dynamic_region ./bitstream/application.bit
write_bitstream -force -cell pfm_top_i/dynamic_region ../zcu102_dfx/_x/link/int/partial.bit
