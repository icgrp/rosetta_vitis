create_pblock pblock_dynamic_region
add_cells_to_pblock [get_pblocks pblock_dynamic_region] [get_cells -quiet [list pfm_top_i/dynamic_region]]
resize_pblock [get_pblocks pblock_dynamic_region] -add {SLICE_X56Y120:SLICE_X95Y179 SLICE_X87Y60:SLICE_X95Y119 SLICE_X77Y60:SLICE_X84Y119 SLICE_X56Y0:SLICE_X95Y59}
resize_pblock [get_pblocks pblock_dynamic_region] -add {CFGIO_SITE_X0Y0:CFGIO_SITE_X0Y0}
resize_pblock [get_pblocks pblock_dynamic_region] -add {DSP48E2_X12Y48:DSP48E2_X17Y71 DSP48E2_X16Y24:DSP48E2_X17Y47 DSP48E2_X12Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks pblock_dynamic_region] -add {IOB_X0Y0:IOB_X0Y37}
resize_pblock [get_pblocks pblock_dynamic_region] -add {RAMB18_X7Y48:RAMB18_X12Y71 RAMB18_X10Y24:RAMB18_X12Y47 RAMB18_X7Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks pblock_dynamic_region] -add {RAMB36_X7Y24:RAMB36_X12Y35 RAMB36_X10Y12:RAMB36_X12Y23 RAMB36_X7Y0:RAMB36_X12Y11}
resize_pblock [get_pblocks pblock_dynamic_region] -add {SYSMONE4_X0Y0:SYSMONE4_X0Y0}
resize_pblock [get_pblocks pblock_dynamic_region] -add {CLOCKREGION_X0Y3:CLOCKREGION_X3Y6 CLOCKREGION_X2Y1:CLOCKREGION_X2Y1}
set_property SNAPPING_MODE ON [get_pblocks pblock_dynamic_region]

