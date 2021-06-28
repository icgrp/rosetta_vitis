module dut(
  input ap_clk,
  input ap_rst_n_inv,
  input ap_rst_n,
  // DMA interface
  input [31:0] aximm2_addr_read_reg_598,
  input v2_buffer_write,
  output v2_buffer_full_n,
  output [31:0] v2_buffer_dout,
  output v2_buffer_empty_n,
  input v2_buffer_read,
  // config input 
  input [63:0] aximm1_addr_read_reg_549,
  input v1_buffer_V_write,
  output v1_buffer_V_full_n,
  output [63:0] v1_buffer_V_dout,
  output v1_buffer_V_empty_n,
  input v1_buffer_V_read
);


wire [48:0] dout_leaf_0;
wire [48:0] dout_leaf_1;
wire [48:0] dout_leaf_2;
wire [48:0] dout_leaf_3;
wire [48:0] dout_leaf_4;
wire [48:0] dout_leaf_5;
wire [48:0] dout_leaf_6;
wire [48:0] dout_leaf_7;

wire [48:0] din_leaf_0;
wire [48:0] din_leaf_1;
wire [48:0] din_leaf_2;
wire [48:0] din_leaf_3;
wire [48:0] din_leaf_4;
wire [48:0] din_leaf_5;
wire [48:0] din_leaf_6;
wire [48:0] din_leaf_7;

wire resend_0;
wire resend_1;
wire resend_2;
wire resend_3;
wire resend_4;
wire resend_5;
wire resend_6;
wire resend_7;

wire [31:0] Output_1_V_TDATA_0;
wire Output_1_V_TVALID_0;
wire Output_1_V_TREADY_0;

wire [31:0] Output_1_V_TDATA_1;
wire Output_1_V_TVALID_1;
wire Output_1_V_TREADY_1;

wire [31:0] Output_1_V_TDATA_2;
wire Output_1_V_TVALID_2;
wire Output_1_V_TREADY_2;

wire [31:0] Output_1_V_TDATA_3;
wire Output_1_V_TVALID_3;
wire Output_1_V_TREADY_3;


wire [63:0] parser_V_TDATA_1;
wire parser_V_TVALID_1;
wire parser_V_TREADY_1;


wire [63:0] parser_V_TDATA_3;
wire parser_V_TVALID_3;
wire parser_V_TREADY_3;
   
    
config_parser config_parser_inst(
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .ap_start(1'b1),
    .ap_done(),
    .ap_idle(),
    .ap_ready(),
    .input1_V_TDATA(aximm1_addr_read_reg_549),
    .input1_V_TVALID(v1_buffer_V_write),
    .input1_V_TREADY(v1_buffer_V_full_n),
    .input2_V_TDATA(aximm2_addr_read_reg_598),
    .input2_V_TVALID(v2_buffer_write),
    .input2_V_TREADY(v2_buffer_full_n),
    .output1_V_TDATA(parser_V_TDATA_1),
    .output1_V_TVALID(parser_V_TVALID_1),
    .output1_V_TREADY(~resend_0),
    .output2_V_TDATA(Output_1_V_TDATA_0),
    .output2_V_TVALID(Output_1_V_TVALID_0),
    .output2_V_TREADY(Output_1_V_TREADY_0),
    .output3_V_TDATA(v1_buffer_V_dout),
    .output3_V_TVALID(v1_buffer_V_empty_n),
    .output3_V_TREADY(v1_buffer_V_read)
    );




assign dout_leaf_0 = {parser_V_TVALID_1, parser_V_TDATA_1[47:0]};

bft bft_inst(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .dout_leaf_0(dout_leaf_0),
    .dout_leaf_1(dout_leaf_1),
    .dout_leaf_2(dout_leaf_2),
    .dout_leaf_3(dout_leaf_3),
    .dout_leaf_4(dout_leaf_4),
    .dout_leaf_5(dout_leaf_5),
    .dout_leaf_6(dout_leaf_6),
    .dout_leaf_7(dout_leaf_7),
    .din_leaf_0(din_leaf_0),
    .din_leaf_1(din_leaf_1),
    .din_leaf_2(din_leaf_2),
    .din_leaf_3(din_leaf_3),
    .din_leaf_4(din_leaf_4),
    .din_leaf_5(din_leaf_5),
    .din_leaf_6(din_leaf_6),
    .din_leaf_7(din_leaf_7),
    .resend_0(resend_0),
    .resend_1(resend_1),
    .resend_2(resend_2),
    .resend_3(resend_3),
    .resend_4(resend_4),
    .resend_5(resend_5),
    .resend_6(resend_6),
    .resend_7(resend_7)
    );


    
InterfaceWrapper1 InterfaceWrapper1_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_1),
    .dout_leaf_interface2bft(dout_leaf_1),
    .resend(resend_1),
    .Input_1_V_V(Output_1_V_TDATA_0),
    .Input_1_V_V_ap_vld(Output_1_V_TVALID_0),
    .Input_1_V_V_ap_ack(Output_1_V_TREADY_0),
    .Output_1_V_V(v2_buffer_dout),
    .Output_1_V_V_ap_vld(v2_buffer_empty_n),
    .Output_1_V_V_ap_ack(v2_buffer_read),
    .reset(ap_rst_n_inv)
    );
    
        

leaf_2 leaf_2_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_2),
    .dout_leaf_interface2bft(dout_leaf_2),
    .resend(resend_2),
    .reset(ap_rst_n_inv)
    );
    
leaf_3 leaf_3_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_3),
    .dout_leaf_interface2bft(dout_leaf_3),
    .resend(resend_3),
    .reset(ap_rst_n_inv)
    );
 
 leaf_4 leaf_4_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_4),
    .dout_leaf_interface2bft(dout_leaf_4),
    .resend(resend_4),
    .reset(ap_rst_n_inv)
    );
    
 leaf_5 leaf_5_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_5),
    .dout_leaf_interface2bft(dout_leaf_5),
    .resend(resend_5),
    .reset(ap_rst_n_inv)
    );
    
 leaf_6 leaf_6_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_6),
    .dout_leaf_interface2bft(dout_leaf_6),
    .resend(resend_6),
    .reset(ap_rst_n_inv)
    );
    
leaf_7 leaf_7_inst(
    .clk(ap_clk),
    .din_leaf_bft2interface(din_leaf_7),
    .dout_leaf_interface2bft(dout_leaf_7),
    .resend(resend_7),
    .reset(ap_rst_n_inv)
    );
    
    
    
endmodule


