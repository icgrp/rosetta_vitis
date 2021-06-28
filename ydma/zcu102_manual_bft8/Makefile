ifndef XILINX_VIVADO
  $(error Environment variable XILINX_VIVADO is required and should point to Vitis install area)
endif


kl_name=ydma
workspace=zcu102_dfx

ifeq (,$(wildcard ./platform/hw_bb_route.dcp))
  $(error cp the hw_bb_route.dcp from <$(workspace)/_link/vivado/vpl/.local/hw_platform> to ./platform)
endif



all: ../$(workspace)/$(kl_name).xclbin 

../$(workspace)/$(kl_name).xclbin:./checkpoint/hw_bb_route.dcp
	cp ./shell/gen_xclbin.sh ../$(workspace)
	cd ../$(workspace) && ./gen_xclbin.sh

./checkpoint/hw_bb_route.dcp: ./checkpoint/pfm_dynamic_new.dcp ./platform/hw_bb_locked.dcp ./tcl/re_impl.tcl
	./shell/run_tcl.sh ./tcl/re_impl.tcl

./checkpoint/pfm_dynamic_new.dcp:./checkpoint/new_kernel.dcp ./checkpoint/pfm_dynamic_bb.dcp ./tcl/replace_sub_module.tcl
	./shell/run_tcl.sh ./tcl/replace_sub_module.tcl

./checkpoint/pfm_dynamic_bb.dcp:./checkpoint/pfm_dynamic.dcp ./tcl/empty_pfm_dynamic.tcl
	./shell/run_tcl.sh ./tcl/empty_pfm_dynamic.tcl

./checkpoint/new_kernel.dcp: ./src/* ./tcl/out_of_context_syn.tcl
	./shell/run_tcl.sh ./tcl/out_of_context_syn.tcl	

./checkpoint/pfm_dynamic.dcp: ../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/gen_pfm_dynamic.tcl
	./shell/run_gen_pfm_dymanic.sh $(workspace) 

../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/gen_pfm_dynamic.tcl:../$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1/pfm_top_wrapper.tcl
	./shell/run_python.sh ./python/modify_tcl.py $(workspace) $(kl_name)


clean:
	rm -rf *.log *.jou *.rpt .Xil hd_visual
