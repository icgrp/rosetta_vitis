set part xczu9eg-ffvb1156-2-e
create_project -in_memory -part $part
add_files ./checkpoint/hw_bb_divided.dcp
add_files ./checkpoint/page.dcp
set_property SCOPED_TO_CELLS {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} [get_files ./checkpoint/page.dcp]
add_files ./xdc/sub.xdc
set_property USED_IN {implementation} [get_files ./xdc/sub.xdc]
set_property PROCESSING_ORDER LATE [get_files ./xdc/sub.xdc]
link_design -mode default -reconfig_partitions {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} -part $part -top pfm_top_wrapper
write_checkpoint -force ./checkpoint/hw_bb_link.dcp
opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force ./checkpoint/hw_bb_routed.dcp
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page2_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page3_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page4_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page5_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page6_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page7_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page8_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page9_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page10_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page11_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page12_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page13_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page14_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page15_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page16_inst
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page17_inst

update_design -cell pfm_top_i/dynamic_region/ydma_1/page2_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page3_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page4_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page5_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page6_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page7_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page8_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page9_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page10_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page11_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page12_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page13_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page14_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page15_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page16_inst -buffer_ports 
update_design -cell pfm_top_i/dynamic_region/ydma_1/page17_inst -buffer_ports 


lock_design -level routing
write_checkpoint -force ./checkpoint/hw_bb_locked_locked.dcp
close_project

create_project -in_memory -part $part
open_checkpoint ./checkpoint/hw_bb_routed.dcp
pr_recombine -cell pfm_top_i/dynamic_region
write_bitstream -force -cell pfm_top_i/dynamic_region ./bitstream/dynamic_region.bit
close_project


