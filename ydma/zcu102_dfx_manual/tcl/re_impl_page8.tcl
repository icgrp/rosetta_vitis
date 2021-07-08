# set page [lindex $argv 0]
set part xczu9eg-ffvb1156-2-e
create_project -in_memory -part $part
add_files ./checkpoint/context_page8.dcp
add_files ./checkpoint/page8.dcp
set_property SCOPED_TO_CELLS { pfm_top_i/dynamic_region/ydma_1/page8_inst } [get_files ./checkpoint/page8.dcp]
link_design -mode default -reconfig_partitions {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} -part xczu9eg-ffvb1156-2-e -top pfm_top_wrapper
opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force ./checkpoint/hw_bb_routed_routed_page8.dcp
write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page8_inst -force ./bitstream/page8.bit
