add_files ./checkpoint/pfm_dynamic_bb.dcp
add_files ./checkpoint/new_kernel.dcp
set_property SCOPED_TO_CELLS { ydma_1 } [get_files ./checkpoint/new_kernel.dcp]
link_design -mode default -part xczu9eg-ffvb1156-2-e -top pfm_dynamic
write_checkpoint -force ./checkpoint/pfm_dynamic_new.dcp


