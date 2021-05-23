`include "define.sv"
module execute(
    input   wire[`NIBBLE]       code,
    input   wire[`NIBBLE]       fn,
    input   wire signed[`D_WORD]  valA,
    input   wire signed[`D_WORD]  valB,
    input   wire[`D_WORD]         valC,
    output  reg signed[`D_WORD]   valE,
    output  reg Cnd
);
reg zf;
reg sf;
reg of;

always @ (*) begin
    case ( code )
        //rrmov  or cmovxx
        `IRRMOVL:   begin
            valE    <=      valA;
            case ( fn )
                `FRRMOVL:      begin
                    Cnd <=      1;
                end
                `FCMOVLE:      begin
                    Cnd <=      (sf ^ of) | zf;
                end
                `FCMOVL:       begin
                    Cnd <=      (sf ^ of);
                end
                `FCMOVE:       begin
                    Cnd <=      zf;
                end
                `FCMOVNE:      begin
                    Cnd <=      ~zf;
                end
                `FCMOVGE:      begin
                    Cnd <=      ~(sf ^ of);
                end
                `FCMOVG:       begin
                    Cnd <=      ~(sf ^ of) & ~zf;
                end
            endcase
        end
        `IIRMOVL:   begin
            valE    <=  valC;
        end
        `IRMMOVL:   begin
            valE    <=  valB + valC;
        end
        `IMRMOVL:   begin
            valE    <=  valB + valC;
        end
        `IOPL:      begin
            case ( fn )
                `FADDL:     begin
                    valE    <=      valB + valA;
                end
                `FSUBL:     begin
                    valE    <=      valB - valA;
                end
                `FANDL:     begin
                    valE    <=      valB & valA;
                end
                `FXORL:     begin
                    valE    <=      valB ^ valA;
                end
            endcase
            //Set CC
            zf      <=      (valE == 0) ;
            sf      <=      valE[`D_WORDNUM-1] ;
            of      <=      ((valA<0 == valB<0) & (valE<0 != valA<0) );
        end
        `IJXX:      begin
            case ( fn )
                `FJMP:      begin
                    Cnd <=      1;
                end
                `FJLE:      begin
                    Cnd <=      (sf ^ of) | zf;
                end
                `FJL:       begin
                    Cnd <=      (sf ^ of);
                end
                `FJE:       begin
                    Cnd <=      zf;
                end
                `FJNE:      begin
                    Cnd <=      ~zf;
                end
                `FJGE:      begin
                    Cnd <=      ~(sf ^ of);
                end
                `FJG:       begin
                    Cnd <=      ~(sf ^ of) & ~zf;
                end
            endcase
        end
        `ICALL:     begin
            valE    <=      valB - 8;
        end

        `IRET:      begin
            valE    <=      valB + 8;
        end

        `IPUSHL:    begin
            valE    <=      valB - 8;
        end

        `IPOPL:     begin
            valE    <=      valB + 8;
        end
        default: begin
            Cnd <= 0; 
        end
    endcase
end


//
// always @ (*) begin
//    e_dstE_o    <=      ~e_Cnd_o?`RNONE:E_dstE_i;
//     case ( E_icode_i )
//         // `IHALT:     begin
//         //     $stop;
//         // end
//         `IRRMOVL:   begin
//             e_valE_o    <=      E_valA_i;
//             case ( E_ifun_i )
//                 `FRRMOVL:      begin
//                     e_Cnd_o <=      1;
//                 end
//                 `FCMOVLE:      begin
//                     e_Cnd_o <=      (sf ^ of) | zf;
//                 end
//                 `FCMOVL:       begin
//                     e_Cnd_o <=      (sf ^ of);
//                 end
//                 `FCMOVE:       begin
//                     e_Cnd_o <=      zf;
//                 end
//                 `FCMOVNE:      begin
//                     e_Cnd_o <=      ~zf;
//                 end
//                 `FCMOVGE:      begin
//                     e_Cnd_o <=      ~(sf ^ of);
//                 end
//                 `FCMOVG:       begin
//                     e_Cnd_o <=      ~(sf ^ of) & ~zf;
//                 end
//             endcase
//
//         end
//
//         `IIRMOVL:   begin
//             e_valE_o    <=      E_valC_i;
//         end
//
//         `IRMMOVL:   begin
//             e_valE_o    <=      E_valB_i + E_valC_i;
//         end
//
//         `IMRMOVL:   begin
//             e_valE_o    <=      E_valB_i + E_valC_i;
//         end
//
//         `IOPL:      begin
//             case ( E_ifun_i )
//                 `FADDL:     begin
//                     e_valE_o    <=      E_valB_i + E_valA_i;
//                 end
//                 `FSUBL:     begin
//                     e_valE_o    <=      E_valB_i - E_valA_i;
//                 end
//                 `FANDL:     begin
//                     e_valE_o    <=      E_valB_i & E_valA_i;
//                 end
//                 `FXORL:     begin
//                     e_valE_o    <=      E_valB_i ^ E_valA_i;
//                 end
//             endcase
//             zf      <=      e_valE_o == 0 ;
//             sf      <=      e_valE_o < 0 ;
//             of      <=      (E_valA_i<0 == E_valB_i<0) && (e_valE_o<0 != E_valA_i<0) ;
//         end
//         `IJXX:      begin
//             case ( E_ifun_i )
//                 `FJMP:      begin
//                     e_Cnd_o <=      1;
//                 end
//                 `FJLE:      begin
//                     e_Cnd_o <=      (sf ^ of) | zf;
//                 end
//                 `FJL:       begin
//                     e_Cnd_o <=      (sf ^ of);
//                 end
//                 `FJE:       begin
//                     e_Cnd_o <=      zf;
//                 end
//                 `FJNE:      begin
//                     e_Cnd_o <=      ~zf;
//                 end
//                 `FJGE:      begin
//                     e_Cnd_o <=      ~(sf ^ of);
//                 end
//                 `FJG:       begin
//                     e_Cnd_o <=      ~(sf ^ of) & ~zf;
//                 end
//             endcase
//         end
//
//         `ICALL:     begin
//             e_valE_o    <=      E_valB_i - 4;
//         end
//
//         `IRET:      begin
//             e_valE_o    <=      E_valB_i + 4;
//         end
//
//         `IPUSHL:    begin
//             e_valE_o    <=      E_valB_i - 4;
//         end
//
//         `IPOPL:     begin
//             e_valE_o    <=      E_valB_i + 4;
//         end
//     endcase
// endcase
// end
endmodule
