//Pointwise Convolution Process Element
`include "define.sv"
module fetch
(
  input  logic  sys_clk,
  input  logic  rst_n,
  input  logic  valid, //启停标志
  input  logic  [`INST_WIDTH-1:0]inst,
  input  logic  [`D_WORD_WIDTH-1:0]val_P_reg,
  output logic  [`NIBBLE_WIDTH-1:0]code,
  output logic  [`NIBBLE_WIDTH-1:0]fn,
  output logic  [`NIBBLE_WIDTH-1:0]rA,
  output logic  [`NIBBLE_WIDTH-1:0]rB,
  output logic  [`D_WORD_WIDTH-1:0]val_C,
  output logic  [`D_WORD_WIDTH-1:0]val_P,
  output logic  [`NIBBLE_WIDTH-1:0]dst_E,
  output logic  [`NIBBLE_WIDTH-1:0]dst_M,
  output logic  inst_valid
);

always @ (*) begin
        code   <=      inst[`ICODE];
        fn    <=      inst[`IFUN];
        case ( code )
            `IHALT:     begin
                // val_P    <=      val_P_reg+4'h1;
                val_P    <=      val_P_reg; //停止
                rA      <=      `RNONE;
                rB      <=      `RNONE;
                val_C    <=      `ZEROD_WORD;
                dst_E    <=      `RNONE;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `INOP:      begin
                val_P    <=      val_P_reg+4'h1;
                rA      <=      `RNONE;
                rB      <=      `RNONE;
                val_C    <=      `ZEROD_WORD;
                dst_E    <=      `RNONE;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IRRMOVL:   begin
                rA      <=      inst[`RA];
                rB      <=      inst[`RB];
                val_P    <=      val_P_reg+4'h2;
                dst_E    <=      inst[`RB];
                val_C    <=      `ZEROD_WORD;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IIRMOVL:   begin
                rA      <=      inst[`RA];
                rB      <=      inst[`RB];
                val_C    <=      {inst[`BYTE9],inst[`BYTE8],inst[`BYTE7],inst[`BYTE6],inst[`BYTE5],inst[`BYTE4],inst[`BYTE3],inst[`BYTE2]};
                val_P    <=      val_P_reg+4'ha;
                dst_E    <=      inst[`RB];

                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IRMMOVL:   begin
                rA      <=      inst[`RA];
                rB      <=      inst[`RB];
                val_C    <=      {inst[`BYTE9],inst[`BYTE8],inst[`BYTE7],inst[`BYTE6],inst[`BYTE5],inst[`BYTE4],inst[`BYTE3],inst[`BYTE2]};
                val_P    <=      val_P_reg+4'ha;

                dst_E    <=      `RNONE;
                dst_M    <=      `RNONE;

                inst_valid <= `ENABLE;
            end
            `IMRMOVL:   begin
                rA      <=      inst[`RA];
                rB      <=      inst[`RB];
                val_C    <=       {inst[`BYTE9],inst[`BYTE8],inst[`BYTE7],inst[`BYTE6],inst[`BYTE5],inst[`BYTE4],inst[`BYTE3],inst[`BYTE2]};
                val_P    <=      val_P_reg+4'ha;
                dst_M    <=      inst[`RA];

                dst_E    <=      `RNONE;

                inst_valid <= `ENABLE;
            end
            `IOPL:      begin
                rA      <=      inst[`RA];
                rB      <=      inst[`RB];
                val_P    <=      val_P_reg+4'h2;
                dst_E    <=      inst[`RB];
                val_C    <=      `ZEROD_WORD;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IJXX:      begin
                val_C    <=      {inst[`BYTE8],inst[`BYTE7],inst[`BYTE6],inst[`BYTE5],inst[`BYTE4],inst[`BYTE3],inst[`BYTE2],inst[`BYTE1]};
                val_P    <=      val_P_reg+4'h9;

                rA      <=      `RNONE;
                rB      <=      `RNONE;
                dst_E    <=      `RNONE;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `ICALL:     begin
                rA      <=      `RESP;
                rB      <=      `RESP;
                val_C    <=      {inst[`BYTE8],inst[`BYTE7],inst[`BYTE6],inst[`BYTE5],inst[`BYTE4],inst[`BYTE3],inst[`BYTE2],inst[`BYTE1]};
                val_P    <=      val_P_reg+4'h9;
                dst_E    <=      `RESP;

                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IRET:      begin
                rA      <=      `RESP;
                rB      <=      `RESP;
                val_P    <=      val_P_reg+4'h1;
                dst_E    <=      `RESP;
                val_C    <=      `ZEROD_WORD;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IPUSHL:    begin
                rA      <=      inst[`RA];
                rB      <=      `RESP;
                val_P    <=      val_P_reg+4'h2;
                dst_E    <=      `RESP;
                val_C    <=      `ZEROD_WORD;
                dst_M    <=      `RNONE;
                inst_valid <= `ENABLE;
            end
            `IPOPL:     begin
                rA      <=      `RESP;
                rB      <=      `RESP;
                val_P    <=      val_P_reg+4'h2;
                dst_E    <=      `RESP;
                dst_M    <=      inst[`RA];
                val_C    <=      `ZEROD_WORD;
                inst_valid <= `ENABLE;
            end
            default: begin
              val_P    <=      val_P_reg+4'h1;
              rA      <=      `RNONE;
              rB      <=      `RNONE;
              val_C    <=      `ZEROD_WORD;
              dst_E    <=      `RNONE;
              dst_M    <=      `RNONE;
              inst_valid <= `DISABLE;
            end 
        endcase
end


endmodule
