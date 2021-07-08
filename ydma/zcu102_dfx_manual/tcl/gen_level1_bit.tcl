create_project -in_memory -part $part
open_checkpoint ./checkpoint/hw_bb_routed.dcp
pr_recombine -cell pfm_top_i/dynamic_region
write_bitstream -force -cell pfm_top_i/dynamic_region ./bitstream/dynamic_region.bit
close_project


