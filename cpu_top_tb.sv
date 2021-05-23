`timescale 1 ns / 1 ps
`include "define.sv"
module cpu_top_tb(

    );
localparam  HALF_PERIOD = 5;
localparam  PERIOD = 10;
logic  sys_clk,rst_n;
logic  valid;
initial $readmemh ( "inst_test.txt",	inst_data );
logic [`BYTE_WIDTH-1:0]inst_data[1023:0];
logic  imem_wr_en;  //
logic  debug;  //调试信号，有效时可以直接获取CPU寄存器值和数据内存
logic  [`BYTE_WIDTH-1:0]imem_wr_data;
logic  [`D_WORD_WIDTH-1:0]imem_wr_addr;
logic  [`BYTE_WIDTH-1:0]dmem_addr_debug;
logic  [`NIBBLE_WIDTH-1:0]reg_addr_debug;


logic  [`D_WORD_WIDTH-1:0]dmem_out_debug;
logic  [`D_WORD_WIDTH-1:0]reg_val_debug;
logic  [`NIBBLE_WIDTH-1:0]status;

integer i;
initial begin
    sys_clk    = 1;
    rst_n      = 1;
    debug = 0;
    imem_wr_en = 0;
    imem_wr_data = 0;
    imem_wr_addr = 0;
    dmem_addr_debug = 0;
    reg_addr_debug = 0;
    #(20*PERIOD)
    rst_n      = 1;
    #HALF_PERIOD
    rst_n      = 0;
    #PERIOD
    rst_n      = 1;
    for(i = 0 ; i < 1024;i++)
    #PERIOD
    begin 
      imem_wr_addr <= i;
      imem_wr_en <= 1;
      imem_wr_data <= inst_data[i];
    end
    #PERIOD
    imem_wr_en <= 0;
    #PERIOD
    valid = 1;
    #(20*PERIOD)
    valid = 0;
    #(10*PERIOD)
$stop;
end
initial forever   #(HALF_PERIOD) sys_clk = ~sys_clk;

    cpu_top
    U_cpu_top
    (
      .sys_clk(sys_clk),
      .rst_n(rst_n),
      .valid(valid),
      .imem_wr_en(imem_wr_en),
      .debug(debug),
      .imem_wr_data(imem_wr_data),
      .imem_wr_addr(imem_wr_addr),
      .dmem_addr_debug(dmem_addr_debug),
      .reg_addr_debug(reg_addr_debug),
      .dmem_out_debug(dmem_out_debug),
      .reg_val_debug(reg_val_debug),
      .status(status)
    );


endmodule
