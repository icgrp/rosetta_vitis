// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Version: 2020.2
// Copyright (C) Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="config_collector_config_collector,hls_ip_2020_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu9eg-ffvb1156-2-e,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=2.322000,HLS_SYN_LAT=27,HLS_SYN_TPT=none,HLS_SYN_MEM=2,HLS_SYN_DSP=0,HLS_SYN_FF=82,HLS_SYN_LUT=237,HLS_VERSION=2020_2}" *)

module config_collector (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        input1_V_TDATA,
        input1_V_TVALID,
        input1_V_TREADY,
        input2_V_TDATA,
        input2_V_TVALID,
        input2_V_TREADY,
        output1_V_TDATA,
        output1_V_TVALID,
        output1_V_TREADY
);

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_pp1_stage0 = 5'd8;
parameter    ap_ST_fsm_state7 = 5'd16;

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [63:0] input1_V_TDATA;
input   input1_V_TVALID;
output   input1_V_TREADY;
input  [63:0] input2_V_TDATA;
input   input2_V_TVALID;
output   input2_V_TREADY;
output  [63:0] output1_V_TDATA;
output   output1_V_TVALID;
input   output1_V_TREADY;

reg ap_done;
reg ap_idle;
reg ap_ready;

 reg    ap_rst_n_inv;
(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    input1_V_TDATA_blk_n;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln169_fu_125_p2;
reg    input2_V_TDATA_blk_n;
wire    ap_CS_fsm_pp1_stage0;
reg    ap_enable_reg_pp1_iter0;
wire    ap_block_pp1_stage0;
wire   [0:0] icmp_ln174_fu_142_p2;
reg    output1_V_TDATA_blk_n;
reg    ap_enable_reg_pp1_iter1;
reg   [0:0] icmp_ln174_reg_172;
reg    ap_enable_reg_pp1_iter2;
reg   [0:0] icmp_ln174_reg_172_pp1_iter1_reg;
reg   [3:0] i_1_reg_108;
wire   [3:0] add_ln169_fu_119_p2;
reg    ap_block_state2;
wire   [3:0] add_ln174_fu_136_p2;
reg    ap_block_state4_pp1_stage0_iter0;
reg    ap_block_state5_pp1_stage0_iter1;
reg    ap_block_state5_io;
reg    ap_block_state6_pp1_stage0_iter2;
reg    ap_block_state6_io;
reg    ap_block_pp1_stage0_11001;
reg   [63:0] tmp_V_reg_176;
wire    ap_CS_fsm_state3;
reg    ap_block_pp1_stage0_subdone;
reg    ap_condition_pp1_exit_iter0_state4;
reg   [7:0] v1_buffer_V_address0;
reg    v1_buffer_V_ce0;
reg    v1_buffer_V_we0;
wire   [63:0] v1_buffer_V_q0;
reg   [3:0] i_reg_97;
wire   [63:0] zext_ln169_fu_131_p1;
wire   [63:0] zext_ln174_fu_148_p1;
reg    ap_block_pp1_stage0_01001;
wire    ap_CS_fsm_state7;
wire    regslice_both_output1_V_U_apdone_blk;
reg   [4:0] ap_NS_fsm;
reg    ap_idle_pp1;
wire    ap_enable_pp1;
wire    regslice_both_input1_V_U_apdone_blk;
wire   [63:0] input1_V_TDATA_int_regslice;
wire    input1_V_TVALID_int_regslice;
reg    input1_V_TREADY_int_regslice;
wire    regslice_both_input1_V_U_ack_in;
wire    regslice_both_input2_V_U_apdone_blk;
wire   [63:0] input2_V_TDATA_int_regslice;
wire    input2_V_TVALID_int_regslice;
reg    input2_V_TREADY_int_regslice;
wire    regslice_both_input2_V_U_ack_in;
wire   [63:0] output1_V_TDATA_int_regslice;
reg    output1_V_TVALID_int_regslice;
wire    output1_V_TREADY_int_regslice;
wire    regslice_both_output1_V_U_vld_out;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 5'd1;
#0 ap_enable_reg_pp1_iter0 = 1'b0;
#0 ap_enable_reg_pp1_iter1 = 1'b0;
#0 ap_enable_reg_pp1_iter2 = 1'b0;
end

config_collector_v1_buffer_V #(
    .DataWidth( 64 ),
    .AddressRange( 256 ),
    .AddressWidth( 8 ))
v1_buffer_V_U(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .address0(v1_buffer_V_address0),
    .ce0(v1_buffer_V_ce0),
    .we0(v1_buffer_V_we0),
    .d0(input1_V_TDATA_int_regslice),
    .q0(v1_buffer_V_q0)
);

config_collector_regslice_both #(
    .DataWidth( 64 ))
regslice_both_input1_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(input1_V_TDATA),
    .vld_in(input1_V_TVALID),
    .ack_in(regslice_both_input1_V_U_ack_in),
    .data_out(input1_V_TDATA_int_regslice),
    .vld_out(input1_V_TVALID_int_regslice),
    .ack_out(input1_V_TREADY_int_regslice),
    .apdone_blk(regslice_both_input1_V_U_apdone_blk)
);

config_collector_regslice_both #(
    .DataWidth( 64 ))
regslice_both_input2_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(input2_V_TDATA),
    .vld_in(input2_V_TVALID),
    .ack_in(regslice_both_input2_V_U_ack_in),
    .data_out(input2_V_TDATA_int_regslice),
    .vld_out(input2_V_TVALID_int_regslice),
    .ack_out(input2_V_TREADY_int_regslice),
    .apdone_blk(regslice_both_input2_V_U_apdone_blk)
);

config_collector_regslice_both #(
    .DataWidth( 64 ))
regslice_both_output1_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(output1_V_TDATA_int_regslice),
    .vld_in(output1_V_TVALID_int_regslice),
    .ack_in(output1_V_TREADY_int_regslice),
    .data_out(output1_V_TDATA),
    .vld_out(regslice_both_output1_V_U_vld_out),
    .ack_out(output1_V_TREADY),
    .apdone_blk(regslice_both_output1_V_U_apdone_blk)
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
        ap_enable_reg_pp1_iter0 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp1_stage0_subdone) & (1'b1 == ap_CS_fsm_pp1_stage0) & (1'b1 == ap_condition_pp1_exit_iter0_state4))) begin
            ap_enable_reg_pp1_iter0 <= 1'b0;
        end else if ((1'b1 == ap_CS_fsm_state3)) begin
            ap_enable_reg_pp1_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_enable_reg_pp1_iter1 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp1_stage0_subdone)) begin
            if ((1'b1 == ap_condition_pp1_exit_iter0_state4)) begin
                ap_enable_reg_pp1_iter1 <= (1'b1 ^ ap_condition_pp1_exit_iter0_state4);
            end else if ((1'b1 == 1'b1)) begin
                ap_enable_reg_pp1_iter1 <= ap_enable_reg_pp1_iter0;
            end
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_enable_reg_pp1_iter2 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp1_stage0_subdone)) begin
            ap_enable_reg_pp1_iter2 <= ap_enable_reg_pp1_iter1;
        end else if ((1'b1 == ap_CS_fsm_state3)) begin
            ap_enable_reg_pp1_iter2 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        i_1_reg_108 <= 4'd0;
    end else if (((icmp_ln174_fu_142_p2 == 1'd0) & (1'b0 == ap_block_pp1_stage0_11001) & (ap_enable_reg_pp1_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        i_1_reg_108 <= add_ln174_fu_136_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        i_reg_97 <= 4'd0;
    end else if ((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (icmp_ln169_fu_125_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        i_reg_97 <= add_ln169_fu_119_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp1_stage0_11001) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        icmp_ln174_reg_172 <= icmp_ln174_fu_142_p2;
        icmp_ln174_reg_172_pp1_iter1_reg <= icmp_ln174_reg_172;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln174_fu_142_p2 == 1'd0) & (1'b0 == ap_block_pp1_stage0_11001) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        tmp_V_reg_176 <= input2_V_TDATA_int_regslice;
    end
end

always @ (*) begin
    if ((icmp_ln174_fu_142_p2 == 1'd1)) begin
        ap_condition_pp1_exit_iter0_state4 = 1'b1;
    end else begin
        ap_condition_pp1_exit_iter0_state4 = 1'b0;
    end
end

always @ (*) begin
    if (((regslice_both_output1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state7))) begin
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
    if (((ap_enable_reg_pp1_iter2 == 1'b0) & (ap_enable_reg_pp1_iter1 == 1'b0) & (ap_enable_reg_pp1_iter0 == 1'b0))) begin
        ap_idle_pp1 = 1'b1;
    end else begin
        ap_idle_pp1 = 1'b0;
    end
end

always @ (*) begin
    if (((regslice_both_output1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state7))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln169_fu_125_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        input1_V_TDATA_blk_n = input1_V_TVALID_int_regslice;
    end else begin
        input1_V_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (icmp_ln169_fu_125_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        input1_V_TREADY_int_regslice = 1'b1;
    end else begin
        input1_V_TREADY_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln174_fu_142_p2 == 1'd0) & (1'b0 == ap_block_pp1_stage0) & (ap_enable_reg_pp1_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        input2_V_TDATA_blk_n = input2_V_TVALID_int_regslice;
    end else begin
        input2_V_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((icmp_ln174_fu_142_p2 == 1'd0) & (1'b0 == ap_block_pp1_stage0_11001) & (ap_enable_reg_pp1_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        input2_V_TREADY_int_regslice = 1'b1;
    end else begin
        input2_V_TREADY_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if ((((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (ap_enable_reg_pp1_iter2 == 1'b1) & (1'b0 == ap_block_pp1_stage0)) | ((icmp_ln174_reg_172 == 1'd0) & (ap_enable_reg_pp1_iter1 == 1'b1) & (1'b0 == ap_block_pp1_stage0) & (1'b1 == ap_CS_fsm_pp1_stage0)))) begin
        output1_V_TDATA_blk_n = output1_V_TREADY_int_regslice;
    end else begin
        output1_V_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((icmp_ln174_reg_172 == 1'd0) & (ap_enable_reg_pp1_iter1 == 1'b1) & (1'b0 == ap_block_pp1_stage0_11001) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        output1_V_TVALID_int_regslice = 1'b1;
    end else begin
        output1_V_TVALID_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp1_stage0) & (ap_enable_reg_pp1_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp1_stage0))) begin
        v1_buffer_V_address0 = zext_ln174_fu_148_p1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        v1_buffer_V_address0 = zext_ln169_fu_131_p1;
    end else begin
        v1_buffer_V_address0 = 'bx;
    end
end

always @ (*) begin
    if (((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (1'b1 == ap_CS_fsm_state2)) | ((1'b0 == ap_block_pp1_stage0_11001) & (ap_enable_reg_pp1_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp1_stage0)))) begin
        v1_buffer_V_ce0 = 1'b1;
    end else begin
        v1_buffer_V_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (icmp_ln169_fu_125_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        v1_buffer_V_we0 = 1'b1;
    end else begin
        v1_buffer_V_we0 = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if ((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (icmp_ln169_fu_125_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else if ((~((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0)) & (icmp_ln169_fu_125_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_pp1_stage0;
        end
        ap_ST_fsm_pp1_stage0 : begin
            if ((~((ap_enable_reg_pp1_iter1 == 1'b0) & (icmp_ln174_fu_142_p2 == 1'd1) & (1'b0 == ap_block_pp1_stage0_subdone) & (ap_enable_reg_pp1_iter0 == 1'b1)) & ~((ap_enable_reg_pp1_iter2 == 1'b1) & (ap_enable_reg_pp1_iter1 == 1'b0) & (1'b0 == ap_block_pp1_stage0_subdone)))) begin
                ap_NS_fsm = ap_ST_fsm_pp1_stage0;
            end else if ((((ap_enable_reg_pp1_iter2 == 1'b1) & (ap_enable_reg_pp1_iter1 == 1'b0) & (1'b0 == ap_block_pp1_stage0_subdone)) | ((ap_enable_reg_pp1_iter1 == 1'b0) & (icmp_ln174_fu_142_p2 == 1'd1) & (1'b0 == ap_block_pp1_stage0_subdone) & (ap_enable_reg_pp1_iter0 == 1'b1)))) begin
                ap_NS_fsm = ap_ST_fsm_state7;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp1_stage0;
            end
        end
        ap_ST_fsm_state7 : begin
            if (((regslice_both_output1_V_U_apdone_blk == 1'b0) & (1'b1 == ap_CS_fsm_state7))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state7;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln169_fu_119_p2 = (i_reg_97 + 4'd1);

assign add_ln174_fu_136_p2 = (i_1_reg_108 + 4'd1);

assign ap_CS_fsm_pp1_stage0 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state7 = ap_CS_fsm[32'd4];

assign ap_block_pp1_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp1_stage0_01001 = (((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (ap_enable_reg_pp1_iter2 == 1'b1) & (output1_V_TREADY_int_regslice == 1'b0)) | ((icmp_ln174_reg_172 == 1'd0) & (ap_enable_reg_pp1_iter1 == 1'b1) & (output1_V_TREADY_int_regslice == 1'b0)) | ((icmp_ln174_fu_142_p2 == 1'd0) & (ap_enable_reg_pp1_iter0 == 1'b1) & (input2_V_TVALID_int_regslice == 1'b0)));
end

always @ (*) begin
    ap_block_pp1_stage0_11001 = (((ap_enable_reg_pp1_iter2 == 1'b1) & ((1'b1 == ap_block_state6_io) | ((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0)))) | ((ap_enable_reg_pp1_iter1 == 1'b1) & ((1'b1 == ap_block_state5_io) | ((icmp_ln174_reg_172 == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0)))) | ((icmp_ln174_fu_142_p2 == 1'd0) & (ap_enable_reg_pp1_iter0 == 1'b1) & (input2_V_TVALID_int_regslice == 1'b0)));
end

always @ (*) begin
    ap_block_pp1_stage0_subdone = (((ap_enable_reg_pp1_iter2 == 1'b1) & ((1'b1 == ap_block_state6_io) | ((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0)))) | ((ap_enable_reg_pp1_iter1 == 1'b1) & ((1'b1 == ap_block_state5_io) | ((icmp_ln174_reg_172 == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0)))) | ((icmp_ln174_fu_142_p2 == 1'd0) & (ap_enable_reg_pp1_iter0 == 1'b1) & (input2_V_TVALID_int_regslice == 1'b0)));
end

always @ (*) begin
    ap_block_state2 = ((icmp_ln169_fu_125_p2 == 1'd0) & (input1_V_TVALID_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state4_pp1_stage0_iter0 = ((icmp_ln174_fu_142_p2 == 1'd0) & (input2_V_TVALID_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state5_io = ((icmp_ln174_reg_172 == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state5_pp1_stage0_iter1 = ((icmp_ln174_reg_172 == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state6_io = ((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state6_pp1_stage0_iter2 = ((icmp_ln174_reg_172_pp1_iter1_reg == 1'd0) & (output1_V_TREADY_int_regslice == 1'b0));
end

assign ap_enable_pp1 = (ap_idle_pp1 ^ 1'b1);

always @ (*) begin
    ap_rst_n_inv = ~ap_rst_n;
end

assign icmp_ln169_fu_125_p2 = ((i_reg_97 == 4'd10) ? 1'b1 : 1'b0);

assign icmp_ln174_fu_142_p2 = ((i_1_reg_108 == 4'd12) ? 1'b1 : 1'b0);

assign input1_V_TREADY = regslice_both_input1_V_U_ack_in;

assign input2_V_TREADY = regslice_both_input2_V_U_ack_in;

assign output1_V_TDATA_int_regslice = (v1_buffer_V_q0 + tmp_V_reg_176);

assign output1_V_TVALID = regslice_both_output1_V_U_vld_out;

assign zext_ln169_fu_131_p1 = i_reg_97;

assign zext_ln174_fu_148_p1 = i_1_reg_108;

endmodule //config_collector