`timescale 1 ns / 1 ps
`include "define.sv"
module fetch_tb(

    );
    function integer clogb2 (input integer bit_depth);
    begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
    bit_depth = bit_depth>>1;
    end
    endfunction
localparam  HALF_PERIOD = 5;
localparam  PERIOD = 10;
localparam  DATA_WIDTH = 8;//8Bit
localparam  FETCH_NUM = 10;// 10Byte
localparam  DATA_DEPTH = 1024; //pin-pong buff buff 3 rows   at one stage
localparam  ADDR_WIDTH = clogb2(DATA_DEPTH);

logic sys_clk,rst_n;
logic  wr_en;
logic  [DATA_WIDTH - 1:0]  wr_data;
 logic  [DATA_WIDTH*8 - 1 : 0]wr_addr; //这里有BUG，如果前面PPF等于四 但只算了三个点，那这个out_VALID就应该修改
 logic  [DATA_WIDTH*8 - 1 : 0]rd_addr;
 logic [DATA_WIDTH*FETCH_NUM - 1:0]  rd_data;

logic [DATA_WIDTH-1:0]halt;
logic [DATA_WIDTH-1:0]nop;
logic [2*DATA_WIDTH-1:0]rrmovq;
logic [10*DATA_WIDTH-1:0]irmovq;
logic [10*DATA_WIDTH-1:0]rmmovq;
logic [10*DATA_WIDTH-1:0]mrmovq;
logic [2*DATA_WIDTH-1:0]opq;
logic [9*DATA_WIDTH-1:0]jxx;
logic [2*DATA_WIDTH-1:0]cmov;
logic [9*DATA_WIDTH-1:0]call;
logic [DATA_WIDTH-1:0]ret;
logic [2*DATA_WIDTH-1:0]pushq;
logic [2*DATA_WIDTH-1:0]popq;

logic  valid; //启停标志
logic  [DATA_WIDTH*FETCH_NUM-1:0]instruction;
logic [3:0]code;
logic [3:0]fn;
logic [3:0]reg_a;
logic [3:0]reg_b;
logic [DATA_WIDTH*8-1:0]val_c;
logic [3:0]f_icode_o;
logic [3:0]f_ifun_o;
logic [3:0]f_rA_o;
logic [3:0]f_rB_o;
logic [DATA_WIDTH*8-1:0]f_valC_o;
logic [DATA_WIDTH*8-1:0]f_valP_o;
logic [3:0]f_dstE_o;
logic [DATA_WIDTH*8-1:0]pc_value;

logic [3:0]f_dstM_o;
logic reg_valid;
logic constant_valid;


logic[`D_WORD]         d_rvalA;
logic[`D_WORD]         d_rvalB;
logic[`D_WORD]       valE;
logic[`NIBBLE]       dstE;
logic                Cnd;
wire[`D_WORD]         mem_data_rd;
wire                  mem_read;
wire                  mem_write;
wire[`D_WORD]         mem_addr;
wire[`D_WORD]         mem_data_wr;
wire[`D_WORD]         val_M;
int data_ppf1[23] = {1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,0,0,0};
int data_ppf2[23] = {0,11,12,13,14,15,16,17,18,19,20,11,12,13,14,15,16,17,18,19,20,0,0};
int data_ppf3[23] = {0,0,21,22,23,24,25,26,27,28,29,30,21,22,23,24,25,26,27,28,29,30,0};
int data_ppf4[23] = {0,0,0,31,32,33,34,35,36,37,38,39,40,31,32,33,34,35,36,37,38,39,40};
int weight_kpf1[23] = {1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,0,0,0};
int weight_kpf2[23] = {0,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,0,0};
int weight_kpf3[23] = {0,0,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,0};
int weight_kpf4[23] = {0,0,0,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8};
integer i,j;
    initial begin
        halt = 8'h00;
        nop = 8'h10;
        rrmovq = 16'h20ab;
        irmovq = 80'h30fb000000000000000d;
        rmmovq = 80'h40ab000000000000000d;
        mrmovq = 80'h50ab000000000000000d;
        opq = 16'h60ab;
        jxx = 72'h70000000000000000c;
        sys_clk    = 1;
        rst_n      = 1;
        wr_addr = 0;
        wr_data = 0;
        wr_en = 0;
        #(20*PERIOD)
        rst_n      = 1;
        #HALF_PERIOD
        rst_n      = 0;
        #PERIOD
        rst_n      = 1;
        // for(i = 0 ; i<1;i++)begin
        // #PERIOD
        // wr_en = 1;
        // wr_addr =  0;
        // wr_data = halt[DATA_WIDTH*1-DATA_WIDTH*i-1-:DATA_WIDTH];
        // end
        //
        // for(i = 0 ; i<1;i++)begin
        // #PERIOD
        // wr_en = 1;
        // wr_addr =  wr_addr + 1;
        // wr_data = nop[DATA_WIDTH*1-DATA_WIDTH*i-1-:DATA_WIDTH];
        // end
        //
        // for(i = 0 ; i<2;i++)begin
        // #PERIOD
        // wr_en = 1;
        // wr_addr =  wr_addr + 1;
        // wr_data = opq[DATA_WIDTH*2-DATA_WIDTH*i-1-:DATA_WIDTH];
        // end
        //
        // for(i = 0 ; i<10;i++)begin
        // #PERIOD
        // wr_en = 1;
        // wr_addr =  wr_addr + 1;
        // wr_data = irmovq[DATA_WIDTH*10-DATA_WIDTH*i-1-:DATA_WIDTH];
        // end
        //
        // for(i = 0 ; i<9;i++)begin
        // #PERIOD
        // wr_en = 1;
        // wr_addr =  wr_addr + 1;
        // wr_data = jxx[DATA_WIDTH*9-DATA_WIDTH*i-1-:DATA_WIDTH];
        // end

        #PERIOD
        wr_en = 0;
        #PERIOD
        valid = 1;
        #(20*PERIOD)
        valid = 0;
        #(10*PERIOD)

		$stop;
    end
    initial forever   #(HALF_PERIOD) sys_clk = ~sys_clk;


    Instruction_memory
    #(
      .FETCH_NUM(FETCH_NUM),
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(DATA_WIDTH*8),
      .DATA_DEPTH(DATA_DEPTH)
    )
    U_Instruction_memory
    (
      .wr_clock(sys_clk),
      .rd_clock(sys_clk),
      .wren(wr_en),
      .wrdata(wr_data),
      .wraddr(wr_addr),
      .rdaddr(rd_addr),
      .rddata(rd_data)
    );


    fetch
    #(
      .FETCH_NUM(FETCH_NUM),
      .DATA_WIDTH(DATA_WIDTH),
      .PC_ADDR(ADDR_WIDTH)
    )
    U_fetch
    (
      .sys_clk(sys_clk),
      .rst_n(rst_n),
      .valid(valid),
      .inst_i(rd_data),
      .val_M(val_M),
      .Cnd(Cnd),
      .f_valP_o(rd_addr),
      .f_icode_o(code),
      .f_ifun_o(fn),
      .f_rA_o(reg_a),
      .f_rB_o(reg_b),
      .f_valC_o(val_c),
      .f_dstE_o(f_dstE_o),
      .f_dstM_o(f_dstM_o),
      .pc_value(pc_value)
    );


    //寄存器读出和写入，这里译码和取指混在一起。
    regfile
    U_regfile(
        .clk(sys_clk),         .rst_n(rst_n),
        .code(code),           .fn(fn),
        .srcA(reg_a),          .srcB(reg_b),
        .dstE(f_dstE_o),       .dstM(f_dstM_o),
        .valE(valE),           .valM(val_M),
        .valA(d_rvalA),        .valB(d_rvalB),
        .Cnd(Cnd)
    );

    execute
    U_execute(
        .code(code),       .fn(fn),
        .valA(d_rvalA),    .valB(d_rvalB),
        .valC(val_c),      .valE(valE),
        .Cnd(Cnd)
    );




memory_access
U_memory_access(
    .code(code),          .valA(d_rvalA),
    .valP(pc_value),      .valE(valE),
    .mem_read(mem_read),  .mem_write(mem_write),
    .mem_addr(mem_addr),  .mem_data_wr(mem_data_wr),
    .mem_data_rd(mem_data_rd), .val_M(val_M)
);

//内存数据
memory
U_memory(
    .clk(sys_clk), 
    .mem_read(mem_read),  .mem_write(mem_write),
    .mem_addr(mem_addr),  .mem_data_wr(mem_data_wr),
    .mem_data_rd(mem_data_rd)
);
endmodule
