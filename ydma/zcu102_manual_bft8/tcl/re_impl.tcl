add_files -quiet ./platform/hw_bb_locked.dcp
add_files -quiet ./checkpoint/pfm_dynamic_new.dcp
link_design -mode default -reconfig_partitions pfm_top_i/dynamic_region -part xczu9eg-ffvb1156-2-e -top pfm_top_wrapper
opt_design
place_design
phys_opt_design
route_design
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets pfm_top_i/dynamic_region/ydma_1/InterfaceWrapper1_inst/leaf_interface_inst/sfc/opc/output_port_cluster[0].OPort/SynFIFO_inst/wptr0]
write_bitstream -force -cell pfm_top_i/dynamic_region ../zcu102_dfx/_x/link/int/partial.bit 
write_checkpoint -force ./checkpoint/hw_bb_route.dcp
