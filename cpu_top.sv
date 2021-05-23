`include "define.sv"
module cpu_top(
  input  logic  sys_clk,
  input  logic  rst_n,
  input  logic  valid,  //CPU启停信号
  input  logic  imem_wr_en,  // 
  input  logic  debug,  //调试信号，有效时可以直接获取CPU寄存器值和数据内存
  input  logic  [`BYTE_WIDTH-1:0]imem_wr_data,
  input  logic  [`D_WORD_WIDTH-1:0]imem_wr_addr,
  input  logic  [`BYTE_WIDTH-1:0]dmem_addr_debug,
  input  logic  [`NIBBLE_WIDTH-1:0]reg_addr_debug,
  output logic  [`D_WORD_WIDTH-1:0]dmem_out_debug,
  output logic  [`D_WORD_WIDTH-1:0]reg_val_debug,
  output logic  [`NIBBLE_WIDTH-1:0]status
);
localparam  FETCH_NUM = 10;
localparam  I_MEM_DEPTH = 1024;
localparam  D_MEM_DEPTH = 1024;
logic  imem_error;
logic  inst_valid;
logic  dmem_error;
//指令存储
logic  [`INST_WIDTH-1:0]inst;
logic  [`NIBBLE_WIDTH-1:0]code;
logic  [`NIBBLE_WIDTH-1:0]fn;
logic  [`NIBBLE_WIDTH-1:0]rA;
logic  [`NIBBLE_WIDTH-1:0]rB;
logic  [`NIBBLE_WIDTH-1:0]srcA;
logic  [`NIBBLE_WIDTH-1:0]srcB;
logic  [`D_WORD_WIDTH-1:0]val_C;
logic  [`NIBBLE_WIDTH-1:0]dst_E;
logic  [`NIBBLE_WIDTH-1:0]dst_M;
logic  [`D_WORD_WIDTH-1:0]val_P;
logic  [`D_WORD_WIDTH-1:0]val_P_reg;

logic  [`D_WORD_WIDTH-1:0]val_rA;
logic  [`D_WORD_WIDTH-1:0]val_rB;
logic  [`D_WORD_WIDTH-1:0]val_E;
logic  cnd;

//数据存储
logic dmem_read;
logic dmem_write;
logic  [`D_WORD_WIDTH-1:0]dmem_rd_data;
logic  [`D_WORD_WIDTH-1:0]dmem_addr;
logic  [`D_WORD_WIDTH-1:0]dmem_wr_data;
logic  [`D_WORD_WIDTH-1:0]val_M;

logic  [`D_WORD_WIDTH-1:0]ma_mem_addr;
logic  ma_mem_read;



//CPU状态更新
stat
U_stat
(
  .imem_error(imem_error),
  .inst_valid(inst_valid),
  .dmem_error(dmem_error),
  .code(code),
  .status(status)
);

//PC计数器更新
pc_select
U_pc_select
(
  .sys_clk(sys_clk),
  .rst_n(rst_n),
  .valid(valid),
  .val_M(val_M),
  .cnd(cnd),
  .val_P_reg(val_P_reg),
  .code(code),
  .val_C(val_C),
  .val_P(val_P)
);

//指令存储
Instruction_memory
#(
  .FETCH_NUM(FETCH_NUM),
  .DATA_WIDTH(`BYTE_WIDTH),
  .ADDR_WIDTH(`D_WORD_WIDTH),
  .DATA_DEPTH(I_MEM_DEPTH)
)
U_Instruction_memory
(
  .clock(sys_clk),
  .wren(imem_wr_en),
  .wrdata(imem_wr_data),
  .wraddr(imem_wr_addr),
  .rdaddr(val_P_reg),
  .rddata(inst),
  .imem_error(imem_error)
);

//取指
fetch
U_fetch
(
  .sys_clk(sys_clk),
  .rst_n(rst_n),
  .valid(valid),
  .inst(inst),
  .val_P(val_P),
  .val_P_reg(val_P_reg),
  .code(code),
  .fn(fn),
  .rA(rA),
  .rB(rB),
  .val_C(val_C),
  .dst_E(dst_E),
  .dst_M(dst_M),
  .inst_valid(inst_valid)
);


//译码
assign srcA = debug?reg_addr_debug:rA;
assign srcB = rB;
assign reg_val_debug = val_rA;
regfile
U_regfile(
    .clk(sys_clk),      .rst_n(rst_n),
    .code(code),        .fn(fn),
    .srcA(srcA),          .srcB(srcB),
    .dstE(dst_E),       .dstM(dst_M),
    .valE(val_E),       .valM(val_M),
    .valA(val_rA),      .valB(val_rB),
    .Cnd(cnd)
);

//执行
execute
U_execute(
    .code(code),      .fn(fn),
    .valA(val_rA),    .valB(val_rB),
    .valC(val_C),     .valE(val_E),
    .Cnd(cnd)
);

//访存
memory_access
U_memory_access(
    .code(code),          .valA(val_rA),
    .valP(val_P),      .valE(val_E),
    .mem_read(ma_mem_read),  .mem_write(dmem_write),
    .mem_addr(ma_mem_addr),  .mem_data_wr(dmem_wr_data),
    .mem_data_rd(dmem_rd_data), .val_M(val_M)
);

//数据存储
//debug
assign dmem_addr = debug?dmem_addr_debug:ma_mem_addr;
assign dmem_out_debug = dmem_rd_data;
assign dmem_read = debug?1:ma_mem_read;

memory
#(
  .DATA_DEPTH(D_MEM_DEPTH)
)
U_memory(
    .clk(sys_clk),
    .mem_read(dmem_read),  .mem_write(dmem_write),
    .mem_addr(dmem_addr),  .mem_data_wr(dmem_wr_data),
    .mem_data_rd(dmem_rd_data), .dmem_error(dmem_error)
);
endmodule
