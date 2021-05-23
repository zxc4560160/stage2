`include "define.sv"
module memory
#(
	DATA_DEPTH = 1024
)
(
	input   logic  clk,
	input	  logic  mem_read,
	input	  logic  mem_write,
	input	  logic[`D_WORD_WIDTH-1:0]  mem_addr,
	input	  logic[`D_WORD_WIDTH-1:0]  mem_data_wr,
	output  logic[`D_WORD_WIDTH-1:0]  mem_data_rd,
	output  logic dmem_error
);

logic [`BYTE_WIDTH-1:0]	mem_data[0:DATA_DEPTH-1];

assign dmem_error = (mem_addr > DATA_DEPTH);

always @ (*)
	if( mem_read)
		mem_data_rd	<=      {mem_data[mem_addr+7],mem_data[mem_addr+6],mem_data[mem_addr+5],mem_data[mem_addr+4],mem_data[mem_addr+3],mem_data[mem_addr+2],mem_data[mem_addr+1],mem_data[mem_addr]};


always @ (posedge clk)
	if(mem_write)
		{mem_data[mem_addr+7],mem_data[mem_addr+6],mem_data[mem_addr+5],mem_data[mem_addr+4],mem_data[mem_addr+3],mem_data[mem_addr+2],mem_data[mem_addr+1],mem_data[mem_addr]} <=      mem_data_wr;


endmodule
