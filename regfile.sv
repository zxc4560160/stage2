`include "define.sv"
module regfile(
	input wire clk,
	input wire rst_n,
  input	wire[`NIBBLE]	    fn,
  input	wire[`NIBBLE]	    code,
  input	wire	            Cnd,
	input	wire[`NIBBLE]	    srcA,
	input	wire[`NIBBLE]	    srcB,
	input	wire[`NIBBLE]	    dstE,
	input	wire[`NIBBLE]	    dstM,
  input	wire[`D_WORD]     valE,
	input	wire[`D_WORD]     valM,
	output	reg[`D_WORD]    valA,
	output	reg[`D_WORD]    valB
);
localparam  REGNUM  = 16;
reg[`D_WORD]	regs[0:REGNUM-1];
integer i ;


always @ (posedge clk or negedge rst_n) begin
if(~rst_n)begin
	for(i=0;i<REGNUM;i++)
		regs[i] <= 0;
end else begin
		if(dstE != `RNONE) begin
	    if((code == `IRRMOVL))begin
	        if((fn != 4'b0)&Cnd)
		       regs[dstE] <=   valE;
	        if(fn == 4'b0)
	         regs[dstE] <=   valE;
	    end
	    else begin
			     regs[dstE] <=  valE;
	    end
		end
		if(dstM != `RNONE) begin
			 regs[dstM] <=   valM;
		end
	end
end

always @ (*) begin
  if(srcA != `RNONE) begin
  	valA <=     regs[srcA];
  end
  if(srcB != `RNONE) begin
    valB <=     regs[srcB];
  end
end


endmodule
