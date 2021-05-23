`include "define.sv"
module memory_access(
    input   logic[`NIBBLE]       code,
    input   logic[`D_WORD]       valA,
    input   logic[`D_WORD]       valP,
    input   logic[`D_WORD]       valE,
    input   logic[`D_WORD]        mem_data_rd,
    output  logic                 mem_read,
    output  logic                 mem_write,
    output  logic[`D_WORD]        mem_addr,
    output  logic[`D_WORD]        mem_data_wr,
    output  logic[`D_WORD]        val_M
);
 
    always @ (*) begin
        case ( code )
            `IRMMOVL:   begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      valE;
                mem_data_wr    <=      valA;
                mem_read    <=      `DISABLE;
            end
            `IMRMOVL:   begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      valE;
                val_M <= mem_data_rd;
                mem_write   <=      `DISABLE;
            end
            `IPUSHL:    begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      valE;
                mem_data_wr    <=      valA;
                mem_read    <=      `DISABLE;
            end
            `IPOPL:     begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      valA;
                mem_write   <=      `DISABLE;
                val_M <= mem_data_rd;
            end
            `ICALL:     begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      valE;
                mem_data_wr    <=      valP;

                mem_read    <=      `DISABLE;
            end
            `IRET:      begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      valA;
                val_M <= mem_data_rd;
                mem_write   <=      `DISABLE;
            end
            default:begin
                mem_addr <= 0;
                mem_read    <=      `DISABLE;
                mem_write   <=      `DISABLE;
                mem_data_wr <= 0;
            end
        endcase
    end

endmodule
