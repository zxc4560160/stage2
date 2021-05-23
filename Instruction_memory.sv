module Instruction_memory //pseudo dual port
#(
   ADDR_WIDTH,
   DATA_WIDTH,
   DATA_DEPTH,
   FETCH_NUM,
   XIL_STYLE = "block"
)
(
  input  logic         clock,
  input  logic                   wren,
  input  logic [ADDR_WIDTH-1:0]  wraddr,
  input  logic [DATA_WIDTH-1:0]  wrdata,
  input  logic [ADDR_WIDTH-1:0]  rdaddr,
  output logic [DATA_WIDTH*FETCH_NUM-1:0]  rddata,
  output logic imem_error
);
integer i;
// initial $readmemh ( "inst_data.txt",	data );
initial $readmemh ( "inst_test.txt",	data );
`ifdef USE_XILINX_IP
(* ram_style = XIL_STYLE  *) logic [DATA_WIDTH-1:0] data [0:DATA_DEPTH-1];
`else
logic [DATA_WIDTH-1:0] data [0:DATA_DEPTH-1] = '{default: {(DATA_WIDTH){1'b0}}};
`endif

assign imem_error = (rdaddr>DATA_DEPTH)|(wraddr>DATA_DEPTH); 

always @(posedge clock)
  if (wren)
  data[wraddr] <= wrdata;

always @(*) begin
  for(i = 0;i<FETCH_NUM;i++)
  rddata[FETCH_NUM*DATA_WIDTH-i*DATA_WIDTH-1-:DATA_WIDTH] <= data[rdaddr+i];
end
endmodule
