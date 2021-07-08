ifndef XILINX_VIVADO
  $(error Environment variable XILINX_VIVADO is required and should point to Vitis install area)
endif

kl_name=ydma
workspace=zcu102_dfx
base_list=page2 page3 page4 page5 #page6 page7 page8 page9 page10 page11 page12 page13 page14 page15 page16 page17
page_dcps=$(addsuffix .dcp, $(addprefix ./checkpoint/, $(base_list)))
page_context_dcps=$(addsuffix .dcp, $(addprefix ./checkpoint/context_, $(base_list)))
page_bits=$(addsuffix .bit, $(addprefix bitstream/, $(base_list)))
xclbins=$(addsuffix .xclbin, $(addprefix xclbin/, $(base_list))) xclbin/dynamic_region.xclbin


all: $(xclbins) 

$(xclbins):xclbin/%.xclbin:./shell/gen.sh bitstream/%.bit
	$^ 

bitstream/dynamic_region.bit: tcl/gen_level1_bit.tcl checkpoint/hw_bb_locked_locked.dcp
	./shell/run_tcl.sh $<
 
bitstreams: $(page_bits)
$(page_bits):bitstream/%.bit:tcl/re_impl_%.tcl checkpoint/context_%.dcp
	./shell/run_tcl.sh $< 
	# ./shell/run_tcl.sh $< $(basename $(subst bitstream/,,$@))

context:$(page_context_dcps)
$(page_context_dcps):./checkpoint/context_%.dcp:./tcl/gen_context_page.tcl ./checkpoint/hw_bb_routed.dcp
	./shell/run_tcl.sh $< $(basename $(subst checkpoint/context_page,page,$@))

app:$(page_dcps)
$(page_dcps):./checkpoint/%.dcp:./tcl/out_of_context_syn_%.tcl src/%  
	./shell/run_tcl.sh $<	
	
./checkpoint/hw_bb_locked_locked.dcp:./checkpoint/hw_bb_divided.dcp ./checkpoint/page.dcp
	./shell/run_tcl.sh ./tcl/mk_overlay.tcl

./checkpoint/page.dcp: ./src4level2/page/* ./tcl/out_of_context_syn_page.tcl
	./shell/run_tcl.sh ./tcl/out_of_context_syn_page.tcl	

./checkpoint/hw_bb_divided.dcp: ./checkpoint/pfm_dynamic_new_bb.dcp ./platform/hw_bb_locked.dcp ./tcl/sub_divided.tcl 
	./shell/run_tcl.sh ./tcl/sub_divided.tcl

./checkpoint/pfm_dynamic_new_bb.dcp:./checkpoint/pfm_dynamic_bb.dcp ./tcl/replace_sub_module.tcl ./checkpoint/$(kl_name)_bb.dcp 
	./shell/run_tcl.sh ./tcl/replace_sub_module_level1.tcl

./checkpoint/$(kl_name)_bb.dcp: ./src4level2/ydma_bb/* ./tcl/out_of_context_syn_$(kl_name)_bb.tcl
	./shell/run_tcl.sh ./tcl/out_of_context_syn_$(kl_name)_bb.tcl	

./checkpoint/pfm_dynamic_bb.dcp:./checkpoint/pfm_dynamic.dcp ./tcl/empty_pfm_dynamic.tcl
	./shell/run_tcl.sh ./tcl/empty_pfm_dynamic.tcl

./checkpoint/pfm_dynamic.dcp: ../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/gen_pfm_dynamic.tcl
	./shell/run_gen_pfm_dymanic.sh $(workspace) 

../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/gen_pfm_dynamic.tcl:../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/pfm_top_wrapper.tcl
	./shell/run_python.sh ./python/modify_tcl.py $(workspace) $(kl_name)



clean:
	rm -rf *.log *.jou *.rpt .Xil hd_visual *.str *.txt
