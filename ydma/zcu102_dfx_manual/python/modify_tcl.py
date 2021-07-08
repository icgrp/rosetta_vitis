#!/usr/bin/env python
import argparse
import os


parser = argparse.ArgumentParser()
parser.add_argument('workspace')
parser.add_argument('-t', '--top', type=str, default="no_func", help="set top function name for out of context synthesis")

args = parser.parse_args()
workspace = args.workspace
top_name  = args.top




# prepare the tcl file to restore the top dcp file
file_in = open('../'+workspace+'/_x/link/vivado/vpl/prj/prj.runs/impl_1/pfm_top_wrapper.tcl', 'r')
file_out = open('../'+workspace+'/_x/link/vivado/vpl/prj/prj.runs/impl_1/gen_pfm_dynamic.tcl', 'w')

copy_enable = True
for line in file_in:
  if copy_enable:
    if (line.replace('set rc [catch {', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('hw_bb_locked.dcp', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('dynamic_impl.xdc', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('dont_partition.xdc', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('_post_sys_link_gen_constrs.xdc', '') != line):
      file_out.write('# ' + line)
    elif (line.replace('link_design', '') != line and line.replace('END', '') != line):
      file_out.write(line)
      copy_enable = False
    elif (line.replace('reconfig_partitions', '') != line):
      file_out.write('# ' + line)
      file_out.write('link_design -part xczu9eg-ffvb1156-2-e -top pfm_dynamic\n') 
      file_out.write('write_checkpoint -force ./pfm_dynamic.dcp\n')
    else:
      file_out.write(line)
      
file_in.close()
file_out.close()


# prepare the tcl file for out-of-context synthesis 
file_in = open('./tcl/out_of_context_syn.tcl', 'r')
file_out = open('./tcl/.tmp.tcl', 'w')

for line in file_in:
  if (line.replace('set top_name', '') != line):
    file_out.write('set top_name ' + top_name + '\n')
  else:
    file_out.write(line)

file_in.close()
file_out.close()

os.system('mv ./tcl/.tmp.tcl ./tcl/out_of_context_syn.tcl')



# prepare the tcl file to empty the kernel out 
file_in = open('./tcl/empty_pfm_dynamic.tcl', 'r')
file_out = open('./tcl/.tmp.tcl', 'w')

for line in file_in:
  if (line.replace('set cell_name', '') != line):
    file_out.write('set cell_name ' + top_name + '\n')
  else:
    file_out.write(line)

file_in.close()
file_out.close()

os.system('mv ./tcl/.tmp.tcl ./tcl/empty_pfm_dynamic.tcl')

# prepare the tcl file to fill out the empty kernel 
file_in = open('./tcl/replace_sub_module.tcl', 'r')
file_out = open('./tcl/.tmp.tcl', 'w')

for line in file_in:
  if (line.replace('set_property SCOPED_TO_CELLS', '') != line):
    file_out.write('set_property SCOPED_TO_CELLS { ' + top_name + '_1 } [get_files ./checkpoint/new_kernel.dcp]\n')
  else:
    file_out.write(line)

file_in.close()
file_out.close()

os.system('mv ./tcl/.tmp.tcl ./tcl/replace_sub_module.tcl')




