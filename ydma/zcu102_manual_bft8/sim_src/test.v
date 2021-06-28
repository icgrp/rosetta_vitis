`timescale 1 ns / 1 ps

module test();


reg  clk_bft;
reg  clk_user;
reg reset_n;
reg ap_start;
reg ap_start_1;

wire [31:0]  din;
wire  val_in;
wire ready_upward;

wire [31:0] m_axis_mm2s_tdata;
wire [15:0]  m_axis_mm2s_tkeep;
wire         m_axis_mm2s_tlast;
reg          m_axis_mm2s_tready;
wire         m_axis_mm2s_tvalid;

reg [48:0] leaf_0_in;
wire [48:0] leaf_0_out2;

/*
floorplan_static_wrapper i1(
    .Input_1_V_V(din),
    .Input_1_V_V_ap_ack(ready_upward),
    .Input_1_V_V_ap_vld(val_in),
    .Output_1_V_V(m_axis_mm2s_tdata),
    .Output_1_V_V_ap_ack(m_axis_mm2s_tready),
    .Output_1_V_V_ap_vld(m_axis_mm2s_tvalid),
    .ap_start(ap_start_1),
    .clk_bft(clk_bft),
    .clk_user(clk_user),
    .leaf_0_in(leaf_0_in),
    .reset_n(reset_n));    
*/

dut i1(
  .ap_clk(clk_user),
  .ap_rst_n_inv(~reset_n),
  .ap_rst_n(reset_n),
  // DMA interface
  .aximm2_addr_read_reg_598(din),
  .v2_buffer_write(val_in),
  .v2_buffer_full_n(ready_upward),
  .v2_buffer_dout(m_axis_mm2s_tdata),
  .v2_buffer_empty_n(m_axis_mm2s_tvalid),
  .v2_buffer_read(m_axis_mm2s_tready),
  // config input 
  .aximm1_addr_read_reg_549({16'd0, leaf_0_in[47:0]}),
  .v1_buffer_V_write(leaf_0_in[48]),
  .v1_buffer_V_full_n(),
  .v1_buffer_V_dout(),
  .v1_buffer_V_empty_n(),
  .v1_buffer_V_read(1'b1)
);
 
    
wire ap_done;
wire ap_idle;
wire ap_ready;

data_gen i2(
    .ap_clk(clk_user),
    .ap_rst_n(reset_n),
    .ap_start(ap_start),
    .ap_done(ap_done),
    .ap_idle(ap_idle),
    .ap_ready(ap_ready),
    .Output_1_V_TDATA(din),
    .Output_1_V_TVALID(val_in),
    .Output_1_V_TREADY(ready_upward)
    //.Output_1_V_V_ap_ack(1'b1)
);


wire [31:0] cnt1;
wire [31:0] cnt2;

counter1 #(
  .CNT_WIDTH(32)
)counter1_1(
  .clk(clk_user),
  .reset(~reset_n),
  .valid(val_in),
  .ready(ready_upward),
  .cnt1(cnt1)
);

counter1 #(
  .CNT_WIDTH(32)
)counter1_2(
  .clk(clk_user),
  .reset(~reset_n),
  .valid(m_axis_mm2s_tvalid),
  .ready(m_axis_mm2s_tready),
  .cnt1(cnt2)
);


always #5 clk_bft = ~clk_bft;
always #5 clk_user = ~clk_user;

initial begin 
    clk_bft = 0;
    clk_user = 0;
    leaf_0_in = 0;
    m_axis_mm2s_tready = 0;
    reset_n = 0;
    ap_start = 0;
    ap_start_1 = 0;
    #1007
    reset_n = 1;
    #100000
    m_axis_mm2s_tready = 1;


  leaf_0_in =49'h1_0000_0000000a;#10
  leaf_0_in =49'h1_0000_00002568;#10
//rasterization2_m.Output_1->zculling_top.Input_1
  leaf_0_in =49'h1_6000_98403f80;#10
  leaf_0_in =49'h1_8200_27200000;#10
//zculling_top.Output_1->coloringFB_bot_m.Input_1
  leaf_0_in =49'h1_8000_9a403f80;#10
  leaf_0_in =49'h1_a200_29200000;#10
//data_redir_m.Output_1->rasterization2_m.Input_1
  leaf_0_in =49'h1_4000_96403f80;#10
  leaf_0_in =49'h1_6200_25200000;#10
//coloringFB_bot_m.Output_1->DMA.Input_1
  leaf_0_in =49'h1_a000_92403f80;#10
  leaf_0_in =49'h1_2200_2b200000;#10
//DMA.Output_1->data_redir_m.Input_1
  leaf_0_in =49'h1_2000_94403f80;#10
  leaf_0_in =49'h1_4200_23200000;#10



    leaf_0_in = 0;
    #100000
    ap_start = 1;
    ap_start_1 = 1;
    #100
    ap_start = 0;
    

    #1_000_000_000
    $stop();

end

endmodule
