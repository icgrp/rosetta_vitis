// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Version: 2020.2
// Copyright (C) Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="coloringFB_bot_m_coloringFB_bot_m,hls_ip_2020_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu9eg-ffvb1156-2-e,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.368625,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=32,HLS_SYN_DSP=0,HLS_SYN_FF=264,HLS_SYN_LUT=1072,HLS_VERSION=2020_2}" *)

module coloringFB_bot_m (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        Input_1_V_TDATA,
        Input_1_V_TVALID,
        Input_1_V_TREADY,
        Output_1_V_TDATA,
        Output_1_V_TVALID,
        Output_1_V_TREADY
);

parameter    ap_ST_fsm_state1 = 10'd1;
parameter    ap_ST_fsm_state2 = 10'd2;
parameter    ap_ST_fsm_state3 = 10'd4;
parameter    ap_ST_fsm_state4 = 10'd8;
parameter    ap_ST_fsm_state5 = 10'd16;
parameter    ap_ST_fsm_state6 = 10'd32;
parameter    ap_ST_fsm_pp2_stage0 = 10'd64;
parameter    ap_ST_fsm_state9 = 10'd128;
parameter    ap_ST_fsm_state10 = 10'd256;
parameter    ap_ST_fsm_state11 = 10'd512;

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] Input_1_V_TDATA;
input   Input_1_V_TVALID;
output   Input_1_V_TREADY;
output  [31:0] Output_1_V_TDATA;
output   Output_1_V_TVALID;
input   Output_1_V_TREADY;

reg ap_done;
reg ap_idle;
reg ap_ready;

 reg    ap_rst_n_inv;
(* fsm_encoding = "none" *) reg   [9:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg   [15:0] counter_V;
reg   [15:0] frame_buffer_V_address0;
reg    frame_buffer_V_ce0;
reg    frame_buffer_V_we0;
reg   [7:0] frame_buffer_V_d0;
wire   [7:0] frame_buffer_V_q0;
reg    Input_1_V_TDATA_blk_n;
wire    ap_CS_fsm_state4;
wire   [0:0] icmp_ln516_fu_360_p2;
reg    Output_1_V_TDATA_blk_n;
wire    ap_CS_fsm_state9;
wire    ap_CS_fsm_state10;
reg   [2:0] k_reg_242;
reg   [31:0] tmp_V_reg_663;
wire   [0:0] icmp_ln870_fu_272_p2;
wire   [16:0] add_ln878_fu_278_p2;
wire    ap_CS_fsm_state2;
wire   [8:0] select_ln506_1_fu_310_p3;
wire   [0:0] icmp_ln878_fu_284_p2;
wire   [8:0] j_V_1_fu_345_p2;
wire   [15:0] empty_12_fu_351_p1;
reg   [15:0] empty_12_reg_693;
wire    ap_CS_fsm_state3;
wire   [15:0] i_V_4_fu_354_p2;
reg    ap_block_state4;
wire   [15:0] add_ln691_fu_403_p2;
wire    ap_CS_fsm_state5;
wire   [14:0] add_ln528_1_fu_419_p2;
reg   [14:0] add_ln528_1_reg_721;
wire    ap_CS_fsm_state6;
wire   [0:0] icmp_ln528_fu_425_p2;
wire   [8:0] select_ln528_fu_445_p3;
reg   [8:0] select_ln528_reg_730;
wire   [8:0] select_ln528_1_fu_453_p3;
reg   [8:0] select_ln528_1_reg_735;
wire   [7:0] trunc_ln529_fu_461_p1;
reg   [7:0] trunc_ln529_reg_741;
wire   [2:0] k_1_fu_465_p2;
wire    ap_CS_fsm_pp2_stage0;
reg    ap_enable_reg_pp2_iter0;
wire    ap_block_state7_pp2_stage0_iter0;
wire    ap_block_state8_pp2_stage0_iter1;
wire    ap_block_pp2_stage0_11001;
wire   [0:0] icmp_ln530_fu_471_p2;
reg   [0:0] icmp_ln530_reg_751;
wire   [1:0] trunc_ln532_fu_498_p1;
reg   [1:0] trunc_ln532_reg_760;
wire   [8:0] add_ln529_fu_652_p2;
reg   [8:0] add_ln529_reg_770;
wire    ap_block_pp2_stage0_subdone;
reg    ap_condition_pp2_exit_iter0_state7;
reg    ap_enable_reg_pp2_iter1;
reg   [16:0] indvar_flatten_reg_165;
reg    ap_block_state1;
reg   [8:0] i_V_reg_176;
reg   [8:0] j_V_reg_187;
reg   [15:0] i_V_2_reg_198;
reg   [14:0] indvar_flatten7_reg_209;
wire   [0:0] icmp_ln870_1_fu_408_p2;
reg   [8:0] i_reg_220;
reg   [8:0] j_reg_231;
reg   [15:0] counter_V_new_0_reg_253;
wire   [63:0] zext_ln510_1_fu_340_p1;
wire   [63:0] zext_ln523_fu_398_p1;
wire   [63:0] zext_ln215_fu_493_p1;
wire    ap_block_pp2_stage0;
wire    ap_CS_fsm_state11;
wire    regslice_both_Output_1_V_U_apdone_blk;
reg   [31:0] out_FB_V_fu_118;
wire   [31:0] out_FB_V_2_fu_641_p2;
wire   [0:0] icmp_ln878_1_fu_296_p2;
wire   [8:0] i_V_3_fu_290_p2;
wire   [7:0] trunc_ln510_fu_318_p1;
wire   [8:0] select_ln506_fu_302_p3;
wire   [15:0] tmp_2_cast_fu_322_p3;
wire   [15:0] zext_ln510_fu_330_p1;
wire   [15:0] add_ln510_fu_334_p2;
wire   [7:0] trunc_ln523_fu_386_p1;
wire   [7:0] pixels_y_V_fu_365_p4;
wire   [15:0] tmp_3_fu_390_p3;
wire   [0:0] tmp_fu_437_p3;
wire   [8:0] add_ln528_fu_431_p2;
wire   [7:0] zext_ln530_fu_477_p1;
wire   [7:0] add_ln532_fu_481_p2;
wire   [16:0] tmp_4_fu_486_p3;
wire   [4:0] shl_ln_fu_502_p3;
wire   [4:0] or_ln532_fu_509_p2;
wire   [5:0] zext_ln414_fu_525_p1;
wire   [0:0] icmp_ln414_fu_519_p2;
wire   [5:0] zext_ln414_1_fu_529_p1;
wire   [5:0] xor_ln414_fu_533_p2;
wire   [5:0] select_ln414_fu_539_p3;
wire   [5:0] select_ln414_2_fu_555_p3;
wire   [5:0] select_ln414_1_fu_547_p3;
wire   [5:0] xor_ln414_1_fu_563_p2;
wire   [31:0] zext_ln215_1_fu_515_p1;
wire   [31:0] zext_ln414_2_fu_569_p1;
wire   [31:0] shl_ln414_fu_581_p2;
reg   [31:0] tmp_2_fu_587_p4;
wire   [31:0] zext_ln414_3_fu_573_p1;
wire   [31:0] zext_ln414_4_fu_577_p1;
wire   [31:0] shl_ln414_1_fu_605_p2;
wire   [31:0] lshr_ln414_fu_611_p2;
wire   [31:0] and_ln414_fu_617_p2;
wire   [31:0] xor_ln414_2_fu_623_p2;
wire   [31:0] select_ln414_3_fu_597_p3;
wire   [31:0] and_ln414_1_fu_629_p2;
wire   [31:0] and_ln414_2_fu_635_p2;
reg   [9:0] ap_NS_fsm;
reg    ap_idle_pp2;
wire    ap_enable_pp2;
wire    regslice_both_Input_1_V_U_apdone_blk;
wire   [31:0] Input_1_V_TDATA_int_regslice;
wire    Input_1_V_TVALID_int_regslice;
reg    Input_1_V_TREADY_int_regslice;
wire    regslice_both_Input_1_V_U_ack_in;
reg    Output_1_V_TVALID_int_regslice;
wire    Output_1_V_TREADY_int_regslice;
wire    regslice_both_Output_1_V_U_vld_out;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 10'd1;
#0 counter_V = 16'd0;
#0 ap_enable_reg_pp2_iter0 = 1'b0;
#0 ap_enable_reg_pp2_iter1 = 1'b0;
end

coloringFB_bot_m_frame_buffer_V #(
    .DataWidth( 8 ),
    .AddressRange( 65536 ),
    .AddressWidth( 16 ))
frame_buffer_V_U(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .address0(frame_buffer_V_address0),
    .ce0(frame_buffer_V_ce0),
    .we0(frame_buffer_V_we0),
    .d0(frame_buffer_V_d0),
    .q0(frame_buffer_V_q0)
);

coloringFB_bot_m_regslice_both #(
    .DataWidth( 32 ))
regslice_both_Input_1_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(Input_1_V_TDATA),
    .vld_in(Input_1_V_TVALID),
    .ack_in(regslice_both_Input_1_V_U_ack_in),
    .data_out(Input_1_V_TDATA_int_regslice),
    .vld_out(Input_1_V_TVALID_int_regslice),
    .ack_out(Input_1_V_TREADY_int_regslice),
    .apdone_blk(regslice_both_Input_1_V_U_apdone_blk)
);

coloringFB_bot_m_regslice_both #(
    .DataWidth( 32 ))
regslice_both_Output_1_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(out_FB_V_fu_118),
    .vld_in(Output_1_V_TVALID_int_regslice),
    .ack_in(Output_1_V_TREADY_int_regslice),
    .data_out(Output_1_V_TDATA),
    .vld_out(regslice_both_Output_1_V_U_vld_out),
    .ack_out(Output_1_V_TREADY),
    .apdone_blk(regslice_both_Output_1_V_U_apdone_blk)
);

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_enable_reg_pp2_iter0 <= 1'b0;
    end else begin
        if (((1'b1 == ap_condition_pp2_exit_iter0_state7) & (1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_subdone))) begin
            ap_enable_reg_pp2_iter0 <= 1'b0;
        end else if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd0))) begin
            ap_enable_reg_pp2_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_enable_reg_pp2_iter1 <= 1'b0;
    end else begin
        if (((1'b1 == ap_condition_pp2_exit_iter0_state7) & (1'b0 == ap_block_pp2_stage0_subdone))) begin
            ap_enable_reg_pp2_iter1 <= (1'b1 ^ ap_condition_pp2_exit_iter0_state7);
        end else if ((1'b0 == ap_block_pp2_stage0_subdone)) begin
            ap_enable_reg_pp2_iter1 <= ap_enable_reg_pp2_iter0;
        end else if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd0))) begin
            ap_enable_reg_pp2_iter1 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd1))) begin
        counter_V_new_0_reg_253 <= 16'd0;
    end else if (((icmp_ln870_1_fu_408_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state5))) begin
        counter_V_new_0_reg_253 <= add_ln691_fu_403_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (icmp_ln516_fu_360_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        i_V_2_reg_198 <= i_V_4_fu_354_p2;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        i_V_2_reg_198 <= 16'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (icmp_ln870_fu_272_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state1))) begin
        i_V_reg_176 <= 9'd0;
    end else if (((icmp_ln878_fu_284_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        i_V_reg_176 <= select_ln506_1_fu_310_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln870_1_fu_408_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
        i_reg_220 <= 9'd0;
    end else if (((1'b1 == ap_CS_fsm_state10) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
        i_reg_220 <= select_ln528_1_reg_735;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln870_1_fu_408_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
        indvar_flatten7_reg_209 <= 15'd0;
    end else if (((1'b1 == ap_CS_fsm_state10) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
        indvar_flatten7_reg_209 <= add_ln528_1_reg_721;
    end
end

always @ (posedge ap_clk) begin
    if ((~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (icmp_ln870_fu_272_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state1))) begin
        indvar_flatten_reg_165 <= 17'd0;
    end else if (((icmp_ln878_fu_284_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        indvar_flatten_reg_165 <= add_ln878_fu_278_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (icmp_ln870_fu_272_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state1))) begin
        j_V_reg_187 <= 9'd0;
    end else if (((icmp_ln878_fu_284_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        j_V_reg_187 <= j_V_1_fu_345_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln870_1_fu_408_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
        j_reg_231 <= 9'd0;
    end else if (((1'b1 == ap_CS_fsm_state10) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
        j_reg_231 <= add_ln529_reg_770;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd0))) begin
        k_reg_242 <= 3'd0;
    end else if (((1'b1 == ap_CS_fsm_pp2_stage0) & (icmp_ln530_fu_471_p2 == 1'd0) & (1'b0 == ap_block_pp2_stage0_11001) & (ap_enable_reg_pp2_iter0 == 1'b1))) begin
        k_reg_242 <= k_1_fu_465_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln870_1_fu_408_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
        out_FB_V_fu_118 <= 32'd0;
    end else if (((1'b1 == ap_CS_fsm_pp2_stage0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (icmp_ln530_reg_751 == 1'd0) & (1'b0 == ap_block_pp2_stage0_11001))) begin
        out_FB_V_fu_118 <= out_FB_V_2_fu_641_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state6)) begin
        add_ln528_1_reg_721 <= add_ln528_1_fu_419_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state9)) begin
        add_ln529_reg_770 <= add_ln529_fu_652_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((regslice_both_Output_1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state11))) begin
        counter_V <= counter_V_new_0_reg_253;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        empty_12_reg_693 <= empty_12_fu_351_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_11001))) begin
        icmp_ln530_reg_751 <= icmp_ln530_fu_471_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd0))) begin
        select_ln528_1_reg_735 <= select_ln528_1_fu_453_p3;
        select_ln528_reg_730 <= select_ln528_fu_445_p3;
        trunc_ln529_reg_741 <= trunc_ln529_fu_461_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        tmp_V_reg_663 <= Input_1_V_TDATA_int_regslice;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp2_stage0) & (icmp_ln530_fu_471_p2 == 1'd0) & (1'b0 == ap_block_pp2_stage0_11001))) begin
        trunc_ln532_reg_760 <= trunc_ln532_fu_498_p1;
    end
end

always @ (*) begin
    if ((((icmp_ln516_fu_360_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | ((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1)))) begin
        Input_1_V_TDATA_blk_n = Input_1_V_TVALID_int_regslice;
    end else begin
        Input_1_V_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (icmp_ln516_fu_360_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | (~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1)))) begin
        Input_1_V_TREADY_int_regslice = 1'b1;
    end else begin
        Input_1_V_TREADY_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state10) | (1'b1 == ap_CS_fsm_state9))) begin
        Output_1_V_TDATA_blk_n = Output_1_V_TREADY_int_regslice;
    end else begin
        Output_1_V_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state9) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
        Output_1_V_TVALID_int_regslice = 1'b1;
    end else begin
        Output_1_V_TVALID_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if ((icmp_ln530_fu_471_p2 == 1'd1)) begin
        ap_condition_pp2_exit_iter0_state7 = 1'b1;
    end else begin
        ap_condition_pp2_exit_iter0_state7 = 1'b0;
    end
end

always @ (*) begin
    if (((regslice_both_Output_1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state11))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp2_iter1 == 1'b0) & (ap_enable_reg_pp2_iter0 == 1'b0))) begin
        ap_idle_pp2 = 1'b1;
    end else begin
        ap_idle_pp2 = 1'b0;
    end
end

always @ (*) begin
    if (((regslice_both_Output_1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state11))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0) & (ap_enable_reg_pp2_iter0 == 1'b1))) begin
        frame_buffer_V_address0 = zext_ln215_fu_493_p1;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        frame_buffer_V_address0 = zext_ln523_fu_398_p1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        frame_buffer_V_address0 = zext_ln510_1_fu_340_p1;
    end else begin
        frame_buffer_V_address0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) | (~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (1'b1 == ap_CS_fsm_state4)) | ((1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_11001) & (ap_enable_reg_pp2_iter0 == 1'b1)))) begin
        frame_buffer_V_ce0 = 1'b1;
    end else begin
        frame_buffer_V_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        frame_buffer_V_d0 = {{Input_1_V_TDATA_int_regslice[23:16]}};
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        frame_buffer_V_d0 = 8'd0;
    end else begin
        frame_buffer_V_d0 = 'bx;
    end
end

always @ (*) begin
    if ((((icmp_ln878_fu_284_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)) | (~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (icmp_ln516_fu_360_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4)))) begin
        frame_buffer_V_we0 = 1'b1;
    end else begin
        frame_buffer_V_we0 = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (icmp_ln870_fu_272_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else if ((~((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0)) & (icmp_ln870_fu_272_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln878_fu_284_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            if ((~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (icmp_ln516_fu_360_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else if ((~((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice)) & (icmp_ln516_fu_360_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state5 : begin
            if (((icmp_ln870_1_fu_408_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state11;
            end
        end
        ap_ST_fsm_state6 : begin
            if (((1'b1 == ap_CS_fsm_state6) & (icmp_ln528_fu_425_p2 == 1'd1))) begin
                ap_NS_fsm = ap_ST_fsm_state11;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end
        end
        ap_ST_fsm_pp2_stage0 : begin
            if (~((icmp_ln530_fu_471_p2 == 1'd1) & (1'b0 == ap_block_pp2_stage0_subdone) & (ap_enable_reg_pp2_iter0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end else if (((icmp_ln530_fu_471_p2 == 1'd1) & (1'b0 == ap_block_pp2_stage0_subdone) & (ap_enable_reg_pp2_iter0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state9;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end
        end
        ap_ST_fsm_state9 : begin
            if (((1'b1 == ap_CS_fsm_state9) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
                ap_NS_fsm = ap_ST_fsm_state10;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state9;
            end
        end
        ap_ST_fsm_state10 : begin
            if (((1'b1 == ap_CS_fsm_state10) & (1'b1 == Output_1_V_TREADY_int_regslice))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state10;
            end
        end
        ap_ST_fsm_state11 : begin
            if (((regslice_both_Output_1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state11))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state11;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Input_1_V_TREADY = regslice_both_Input_1_V_U_ack_in;

assign Output_1_V_TVALID = regslice_both_Output_1_V_U_vld_out;

assign add_ln510_fu_334_p2 = (tmp_2_cast_fu_322_p3 + zext_ln510_fu_330_p1);

assign add_ln528_1_fu_419_p2 = (indvar_flatten7_reg_209 + 15'd1);

assign add_ln528_fu_431_p2 = (i_reg_220 + 9'd1);

assign add_ln529_fu_652_p2 = (select_ln528_reg_730 + 9'd4);

assign add_ln532_fu_481_p2 = (zext_ln530_fu_477_p1 + trunc_ln529_reg_741);

assign add_ln691_fu_403_p2 = (counter_V + 16'd1);

assign add_ln878_fu_278_p2 = (indvar_flatten_reg_165 + 17'd1);

assign and_ln414_1_fu_629_p2 = (xor_ln414_2_fu_623_p2 & out_FB_V_fu_118);

assign and_ln414_2_fu_635_p2 = (select_ln414_3_fu_597_p3 & and_ln414_fu_617_p2);

assign and_ln414_fu_617_p2 = (shl_ln414_1_fu_605_p2 & lshr_ln414_fu_611_p2);

assign ap_CS_fsm_pp2_stage0 = ap_CS_fsm[32'd6];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state10 = ap_CS_fsm[32'd8];

assign ap_CS_fsm_state11 = ap_CS_fsm[32'd9];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign ap_CS_fsm_state6 = ap_CS_fsm[32'd5];

assign ap_CS_fsm_state9 = ap_CS_fsm[32'd7];

assign ap_block_pp2_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp2_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp2_stage0_subdone = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state1 = ((1'b0 == Input_1_V_TVALID_int_regslice) | (ap_start == 1'b0));
end

always @ (*) begin
    ap_block_state4 = ((icmp_ln516_fu_360_p2 == 1'd0) & (1'b0 == Input_1_V_TVALID_int_regslice));
end

assign ap_block_state7_pp2_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state8_pp2_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_enable_pp2 = (ap_idle_pp2 ^ 1'b1);

always @ (*) begin
    ap_rst_n_inv = ~ap_rst_n;
end

assign empty_12_fu_351_p1 = tmp_V_reg_663[15:0];

assign i_V_3_fu_290_p2 = (i_V_reg_176 + 9'd1);

assign i_V_4_fu_354_p2 = (i_V_2_reg_198 + 16'd1);

assign icmp_ln414_fu_519_p2 = ((shl_ln_fu_502_p3 > or_ln532_fu_509_p2) ? 1'b1 : 1'b0);

assign icmp_ln516_fu_360_p2 = ((i_V_2_reg_198 == empty_12_reg_693) ? 1'b1 : 1'b0);

assign icmp_ln528_fu_425_p2 = ((indvar_flatten7_reg_209 == 15'd16384) ? 1'b1 : 1'b0);

assign icmp_ln530_fu_471_p2 = ((k_reg_242 == 3'd4) ? 1'b1 : 1'b0);

assign icmp_ln870_1_fu_408_p2 = ((add_ln691_fu_403_p2 == 16'd3192) ? 1'b1 : 1'b0);

assign icmp_ln870_fu_272_p2 = ((counter_V == 16'd0) ? 1'b1 : 1'b0);

assign icmp_ln878_1_fu_296_p2 = ((j_V_reg_187 == 9'd256) ? 1'b1 : 1'b0);

assign icmp_ln878_fu_284_p2 = ((indvar_flatten_reg_165 == 17'd65536) ? 1'b1 : 1'b0);

assign j_V_1_fu_345_p2 = (select_ln506_fu_302_p3 + 9'd1);

assign k_1_fu_465_p2 = (k_reg_242 + 3'd1);

assign lshr_ln414_fu_611_p2 = 32'd4294967295 >> zext_ln414_4_fu_577_p1;

assign or_ln532_fu_509_p2 = (shl_ln_fu_502_p3 | 5'd7);

assign out_FB_V_2_fu_641_p2 = (and_ln414_2_fu_635_p2 | and_ln414_1_fu_629_p2);

assign pixels_y_V_fu_365_p4 = {{Input_1_V_TDATA_int_regslice[15:8]}};

assign select_ln414_1_fu_547_p3 = ((icmp_ln414_fu_519_p2[0:0] == 1'b1) ? zext_ln414_1_fu_529_p1 : zext_ln414_fu_525_p1);

assign select_ln414_2_fu_555_p3 = ((icmp_ln414_fu_519_p2[0:0] == 1'b1) ? xor_ln414_fu_533_p2 : zext_ln414_fu_525_p1);

assign select_ln414_3_fu_597_p3 = ((icmp_ln414_fu_519_p2[0:0] == 1'b1) ? tmp_2_fu_587_p4 : shl_ln414_fu_581_p2);

assign select_ln414_fu_539_p3 = ((icmp_ln414_fu_519_p2[0:0] == 1'b1) ? zext_ln414_fu_525_p1 : zext_ln414_1_fu_529_p1);

assign select_ln506_1_fu_310_p3 = ((icmp_ln878_1_fu_296_p2[0:0] == 1'b1) ? i_V_3_fu_290_p2 : i_V_reg_176);

assign select_ln506_fu_302_p3 = ((icmp_ln878_1_fu_296_p2[0:0] == 1'b1) ? 9'd0 : j_V_reg_187);

assign select_ln528_1_fu_453_p3 = ((tmp_fu_437_p3[0:0] == 1'b1) ? add_ln528_fu_431_p2 : i_reg_220);

assign select_ln528_fu_445_p3 = ((tmp_fu_437_p3[0:0] == 1'b1) ? 9'd0 : j_reg_231);

assign shl_ln414_1_fu_605_p2 = 32'd4294967295 << zext_ln414_3_fu_573_p1;

assign shl_ln414_fu_581_p2 = zext_ln215_1_fu_515_p1 << zext_ln414_2_fu_569_p1;

assign shl_ln_fu_502_p3 = {{trunc_ln532_reg_760}, {3'd0}};

assign tmp_2_cast_fu_322_p3 = {{trunc_ln510_fu_318_p1}, {8'd0}};

integer ap_tvar_int_0;

always @ (shl_ln414_fu_581_p2) begin
    for (ap_tvar_int_0 = 32 - 1; ap_tvar_int_0 >= 0; ap_tvar_int_0 = ap_tvar_int_0 - 1) begin
        if (ap_tvar_int_0 > 31 - 0) begin
            tmp_2_fu_587_p4[ap_tvar_int_0] = 1'b0;
        end else begin
            tmp_2_fu_587_p4[ap_tvar_int_0] = shl_ln414_fu_581_p2[31 - ap_tvar_int_0];
        end
    end
end

assign tmp_3_fu_390_p3 = {{trunc_ln523_fu_386_p1}, {pixels_y_V_fu_365_p4}};

assign tmp_4_fu_486_p3 = {{select_ln528_1_reg_735}, {add_ln532_fu_481_p2}};

assign tmp_fu_437_p3 = j_reg_231[32'd8];

assign trunc_ln510_fu_318_p1 = select_ln506_1_fu_310_p3[7:0];

assign trunc_ln523_fu_386_p1 = Input_1_V_TDATA_int_regslice[7:0];

assign trunc_ln529_fu_461_p1 = select_ln528_fu_445_p3[7:0];

assign trunc_ln532_fu_498_p1 = k_reg_242[1:0];

assign xor_ln414_1_fu_563_p2 = (select_ln414_fu_539_p3 ^ 6'd31);

assign xor_ln414_2_fu_623_p2 = (32'd4294967295 ^ and_ln414_fu_617_p2);

assign xor_ln414_fu_533_p2 = (zext_ln414_fu_525_p1 ^ 6'd31);

assign zext_ln215_1_fu_515_p1 = frame_buffer_V_q0;

assign zext_ln215_fu_493_p1 = tmp_4_fu_486_p3;

assign zext_ln414_1_fu_529_p1 = or_ln532_fu_509_p2;

assign zext_ln414_2_fu_569_p1 = select_ln414_2_fu_555_p3;

assign zext_ln414_3_fu_573_p1 = select_ln414_1_fu_547_p3;

assign zext_ln414_4_fu_577_p1 = xor_ln414_1_fu_563_p2;

assign zext_ln414_fu_525_p1 = shl_ln_fu_502_p3;

assign zext_ln510_1_fu_340_p1 = add_ln510_fu_334_p2;

assign zext_ln510_fu_330_p1 = select_ln506_fu_302_p3;

assign zext_ln523_fu_398_p1 = tmp_3_fu_390_p3;

assign zext_ln530_fu_477_p1 = k_reg_242;

endmodule //coloringFB_bot_m
