#!/usr/bin/env python
import argparse
import os

for i in range(2, 18):
  file_out = open('./tcl/re_impl_page'+str(i)+'.tcl', 'w')
  file_out.write('# set page [lindex $argv 0]\n')
  file_out.write('set part xczu9eg-ffvb1156-2-e\n')
  file_out.write('create_project -in_memory -part $part\n')
  file_out.write('add_files ./checkpoint/context_page'+str(i)+'.dcp\n')
  file_out.write('add_files ./checkpoint/page'+str(i)+'.dcp\n')
  file_out.write('set_property SCOPED_TO_CELLS { pfm_top_i/dynamic_region/ydma_1/page'+str(i)+'_inst } [get_files ./checkpoint/page'+str(i)+'.dcp]\n')


  file_out.write('link_design -mode default -reconfig_partitions {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst} -part xczu9eg-ffvb1156-2-e -top pfm_top_wrapper\n')
  file_out.write('opt_design\n')
  file_out.write('place_design\n')
  file_out.write('phys_opt_design\n')
  file_out.write('route_design\n')
  file_out.write('write_checkpoint -force ./checkpoint/hw_bb_routed_routed_page'+str(i)+'.dcp\n')
  file_out.write('write_bitstream -cell pfm_top_i/dynamic_region/ydma_1/page'+str(i)+'_inst -force ./bitstream/page'+str(i)+'.bit\n')

