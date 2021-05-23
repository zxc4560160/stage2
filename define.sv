`define     IHALT           4'H0
`define     INOP            4'H1
`define     IRRMOVL         4'H2
`define     IIRMOVL         4'H3
`define     IRMMOVL         4'H4
`define     IMRMOVL         4'H5
`define     IOPL            4'H6
`define     IJXX            4'H7
`define     ICALL           4'H8
`define     IRET            4'H9
`define     IPUSHL          4'HA
`define     IPOPL           4'HB

//Function codes
`define     FNONE           4'H0
`define     FADDL           4'H0
`define     FSUBL           4'H1
`define     FANDL           4'H2
`define     FXORL           4'H3
`define     FJMP            4'H0
`define     FJLE            4'H1
`define     FJL             4'H2
`define     FJE             4'H3
`define     FJNE            4'H4
`define     FJGE            4'H5
`define     FJG             4'H6
`define     FRRMOVL         4'H0
`define     FCMOVLE         4'H1
`define     FCMOVL          4'H2
`define     FCMOVE          4'H3
`define     FCMOVNE         4'H4
`define     FCMOVGE         4'H5
`define     FCMOVG          4'H6

//Register Codes
`define     RESP            4'H4
`define     RNONE           4'HF

//Status Codes
`define     SAOK            4'H1
`define     SADR            4'H2
`define     SINS            4'H3
`define     SHLT            4'H4

//Size Codes
`define     NIBBLE          3:0
`define     ZERONIBBLE      4'h0
`define     BYTE            7:0
`define     BYTE0           79:72
`define     BYTE1           71:64
`define     BYTE2           63:56
`define     BYTE3           55:48
`define     BYTE4           47:40
`define     BYTE5           39:32
`define     BYTE6           31:24
`define     BYTE7           23:16
`define     BYTE8           15:8
`define     BYTE9           7:0
`define     WORD            31:0
`define     ZEROWORD        32'h0
`define     D_WORD            63:0
`define     ZEROD_WORD        64'h0
`define     INSTBUS         79:0
`define     ICODE           79:76
`define     IFUN            75:72
`define     RA              71:68
`define     RB              67:64
`define     DEST            71:40
`define     INSTMEMNUM      2048
`define     WORDNUM         32
`define     D_WORDNUM         64
`define     REGNUM          16

`define     INST_WIDTH          80
`define   D_WORD_WIDTH 64
`define   NIBBLE_WIDTH 4
`define   BYTE_WIDTH 8
`define     PC_WIDTH          31:0

// `define     NIBBLE_WIDTH          3:0
`define     CONSTANT_WIDTH          63:0

//Other Codes
`define     ENABLE          1'b1
`define     DISABLE         1'b0
`define     ALUADD          4'H0
