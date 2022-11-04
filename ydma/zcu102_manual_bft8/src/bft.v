module bft(
  input clk,
  input reset,
  input [48:0]dout_leaf_0,
  input [48:0]dout_leaf_1,
  input [48:0]dout_leaf_2,
  input [48:0]dout_leaf_3,
  input [48:0]dout_leaf_4,
  input [48:0]dout_leaf_5,
  input [48:0]dout_leaf_6,
  input [48:0]dout_leaf_7,
  output [48:0]din_leaf_0,
  output [48:0]din_leaf_1,
  output [48:0]din_leaf_2,
  output [48:0]din_leaf_3,
  output [48:0]din_leaf_4,
  output [48:0]din_leaf_5,
  output [48:0]din_leaf_6,
  output [48:0]din_leaf_7,
  output resend_0,
  output resend_1,
  output resend_2,
  output resend_3,
  output resend_4,
  output resend_5,
  output resend_6,
  output resend_7);
    // empty
    gen_nw8 # (
        .num_leaves(8),
        .payload_sz(45),
        .p_sz(49),
        .addr(1'b0),
        .level(0)
        ) gen_nw8 (
        .clk(clk),
        .reset(reset),
        .pe_interface(
            {
            dout_leaf_7,
            dout_leaf_6,
            dout_leaf_5,
            dout_leaf_4,
            dout_leaf_3,
            dout_leaf_2,
            dout_leaf_1,
            dout_leaf_0}),
        .interface_pe(
            {
           din_leaf_7,
           din_leaf_6,
           din_leaf_5,
           din_leaf_4,
           din_leaf_3,
           din_leaf_2,
           din_leaf_1,
           din_leaf_0}),
        .resend(
            {
            resend_7,
            resend_6,
            resend_5,
            resend_4,
            resend_3,
            resend_2,
            resend_1,
            resend_0})
    );
endmodule