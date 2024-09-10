module Execute_Stage (
    input wire RegDstE, 
    input wire [1:0] ALUSrcE,
    input wire [4:0] shamtE,
    input wire  [4:0]       ALUControlE,
    input  wire  [31:0]      Rd1D, Rd2D,
    input  wire  [4:0]  RsE, RtE, RdE,
    input wire [15:0] immE,
    input     wire  [31:0]      signImmE,
    input     wire  [31:0]      ALUOutMOut, ResultW,
    input     wire  [1:0]       ForwardAE, ForwardBE,
    output    wire  [4:0]       RsEtoHazardUnit, RtEtoHazardUnit,
    //output wire ZeroE,
    output    wire  [4:0]       WriteRegE,
    output    wire  [31:0]      WriteDataE, ALUOutE
);

wire   [31:0]   srcAE, srcBE;

assign RsEtoHazardUnit = RsE;
assign RtEtoHazardUnit = RtE;

mux2to1 #(5) MUX2
(
.in1 (RtE), 
.in2 (RdE), 
.sel (RegDstE),
.out (WriteRegE)
);

mux4to1 #(5) MUX3
(
.in1 (WriteDataE),  //data from RF
.in2 (signImmE), //signed extend
.in3({16'd0,immE}),//zero extend 
.sel (ALUSrcE),
.out (srcBE)

);
mux4to1 #(32) MUX4 (

.in1(Rd1D),
.in2(ResultW),
.in3(ALUOutMOut),
.sel(ForwardAE),
.out(srcAE)
);

mux4to1 #(32) MUX5 (
.in1(Rd2D),
.in2(ResultW),
.in3(ALUOutMOut),
.sel(ForwardBE),
.out(WriteDataE)
);


ALU #(32) ALU_inst 
(
.SrcA(srcAE),
.SrcB(srcBE),
.ALU_CTRL(ALUControlE),
.shamt(shamtE),
//.Zero(ZeroE),
.ALU_Result(ALUOutE)
);




endmodule