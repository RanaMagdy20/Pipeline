module Decode_Stage (
    input wire CLK,RST,
    input  wire  RegWriteW,
    input wire [1:0] multiply,divide,
    input    wire   [31:0]  InstrD, ResultW, ALUOutM, PCPlus4D,
    input    wire   [4:0]   WriteRegW,
    input    wire           forwardAD, forwardBD,

   // output   wire   [5:0]   Opcode, func,
    output   wire   [31:0]  rd1D, rd2D, signImmD,
    output   wire   [31:0]  PCBranchD, PCJumpD,
    output   wire   [4:0]   rsD, rtD, rdE,
    output wire [4:0] shamtD,
    output wire [15:0] immD,
    output wire [63:0] mult_result,div_result,
    output   wire           EqualD
);


wire    [31:0]  EqualD_in1, EqualD_in2;
assign PCBranchD= (signImmD<<2) + PCPlus4D;
assign PCJumpD = {PCPlus4D[31:28],{InstrD[25:0]<<2}};

//assign  Opcode  =  InstrD[31:26];
//assign  func  =  InstrD[5:0];
assign  rsD  =  InstrD[25:21];
assign  rtD   =  InstrD[20:16];
assign  rdE   =  InstrD[15:11];
assign shamtD =   InstrD[10:6];
assign immD = InstrD[15:0];



Sign_Ext #(32) signext (
.instr_Imm(InstrD[15:0]),
.sign_Imm(signImmD)

);




Register_File #(32,32) RF (
.CLK(CLK),
.RST(RST),
.WE(RegWriteW),
.RD1(rd1D),
.RD2(rd2D),
.WD3(ResultW),
.A1(InstrD[25:21]),
.A2(InstrD[20:16]),
.A3(WriteRegW)
);

mux2to1 #(32) MUX6 (
.in1(rd1D),
.in2(ALUOutM),
.sel(forwardAD),
.out(EqualD_in1)
);

mux2to1 #(32)  MUX7 (
.in1(rd2D),
.in2(ALUOutM),
.sel(forwardBD),
.out(EqualD_in2)
      
);

assign EqualD =(EqualD_in1 == EqualD_in2) ? 'd1 : 'd0;

mult #(32) Multiplyy
(
.A(rd1D),
.B(rd2D),
.enable(multiply[1]), 
.sign(multiply[0]),  
.C(mult_result)
);

div #(32) Dividee
(
.A(rd1D),
.B(rd2D),
.enable(divide[1]), 
.sign(divide[0]),  
.C(div_result)
);








endmodule