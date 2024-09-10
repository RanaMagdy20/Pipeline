module Memory_Register (
        input  wire CLK, RST,
    input wire regWriteE, memToRegE, memWriteE, 
    input wire [1:0] storeE,
    input  wire   [31:0]    aluOutE, writeDataE,
    input wire   [4:0]     writeRegE,
    output reg   regWriteM, memToRegM, memWriteM, 
    output reg [1:0] storeM,
    output reg   [31:0]  aluOutM, writeDataM,
    output  reg   [4:0]    writeRegM
);

always @(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                regWriteM  <=    1'b0; 
                memToRegM  <=    1'b0;
                memWriteM  <=    1'b0;
                storeM <=   2'b0;
                aluOutM    <=    32'b0; 
                writeDataM <=    32'b0;
                writeRegM  <=    5'b0;
            end
        else
            begin
                regWriteM  <=   regWriteE; 
                memToRegM  <=   memToRegE;
                storeM <= storeE;
                memWriteM   <=   memWriteE;
                aluOutM  <=   aluOutE; 
                writeDataM  <=   writeDataE;
                writeRegM  <=   writeRegE;
            end
    end
endmodule 