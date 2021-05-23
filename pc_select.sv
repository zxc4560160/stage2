//Pointwise Convolution Process Element

`include "define.sv"
module pc_select
(
  input  logic sys_clk,
  input  logic rst_n,
  input  logic valid, //启停标志
  input  logic cnd,
  input  logic [`D_WORD_WIDTH-1:0]val_M,
  input  logic [`NIBBLE_WIDTH-1:0]code,
  input  logic [`D_WORD_WIDTH-1:0]val_P,
  input  logic [`D_WORD_WIDTH-1:0]val_C,
  output logic [`D_WORD_WIDTH-1:0]val_P_reg
);

always_ff @(posedge sys_clk or negedge rst_n)
  if(~rst_n)
    val_P_reg <=  0;
  else if(valid)begin
    if(code == `IRET)    // val_P_reg <= val_P;
    val_P_reg <= val_M;
    else if(code == `ICALL)
    val_P_reg <= val_C;
    else if(code == `IJXX)
    val_P_reg <= cnd?val_C:val_P;
    else
    val_P_reg <= val_P;
  end

endmodule
