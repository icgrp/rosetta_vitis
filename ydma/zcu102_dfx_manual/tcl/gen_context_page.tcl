set page [lindex $argv 0]
open_checkpoint ./checkpoint/hw_bb_locked_locked.dcp
update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/${page}_inst
write_checkpoint -force ./checkpoint/context_${page}.dcp
