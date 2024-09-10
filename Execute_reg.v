module Execute_Register (
    input  wire CLK, RST, CLR,   
    input  wire  regWriteD, memToRegD, memWriteD, regDstD, 
    input wire [1:0] aluSrcD,
    input wire [1:0] storeD,
    input wire [4:0] shamtD,
    input wire [15:0] immD,
    input  wire   [4:0]     aluControlD,
    input  wire   [31:0]    rd1D, rd2D,
    input  wire   [4:0]     rsD,  rtD,  rdD,
    input  wire   [31:0]    signImmD, 
    output reg  regWriteE,  memToRegE, memWriteE, regDstE, 
    output reg [1:0] storeE, aluSrcE,
    output reg    [4:0]     aluControlE, 
    output reg    [31:0]    rd1E,  rd2E,
    output reg    [4:0]     rsE,  rtE,  rdE,
    output reg [4:0] shamtE,
    output reg [15:0] immE,
    output reg    [31:0]    signImmE 
  
);


always @ (posedge CLK or negedge RST)
    begin 
        if (CLR | !RST)
            begin
                regWriteE  <=  1'b0;
                memToRegE  <=  1'b0;
                memWriteE  <=  1'b0;
                aluControlE <=  2'b0;
                aluSrcE   <=  1'b0;
                regDstE<=  1'b0;
                storeE <=2'b0;
                rd1E <=  32'b0;
                rd2E  <=  32'b0;
                rsE    <=  5'b0;
                rtE   <=  5'b0;
                rdE     <=  5'b0;
                immE <='d0;
                shamtE <='d0;
                signImmE   <=  32'b0;
            end
        else
            begin
                regWriteE   <=  regWriteD;
                storeE <= storeD;
                memToRegE   <=  memToRegD;
                memWriteE   <=  memWriteD;
                aluControlE <=  aluControlD;
                aluSrcE    <=  aluSrcD;
                regDstE    <=  regDstD;
                rd1E    <=  rd1D;
                rd2E  <=  rd2D;
                rsE    <=  rsD;
                rtE <=  rtD;
                rdE    <=  rdD;
                shamtE <= shamtD;
                immE <= immD;
                signImmE <=  signImmD;
            end  
    end

endmodule