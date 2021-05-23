`include "define.sv"
module stat
(
	input   logic  imem_error,
	input	  logic  inst_valid,
	input	  logic  dmem_error,
  input  logic  [`NIBBLE_WIDTH-1:0]code,
  output logic  [`NIBBLE_WIDTH-1:0]status
);

assign status = (imem_error|dmem_error)?`SADR:(~inst_valid)?`SINS:(code== `IHALT)?`SHLT:`SAOK;
endmodule
