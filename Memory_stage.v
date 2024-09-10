module Memory_Stage (
    
    input  wire  CLK, RST,
    input  wire  [4:0]   WriteRegM_IN, 
    input wire [1:0] storeM,
    input  wire  [31:0]  ALUOutM_IN, WriteDataM, 
    input  wire   MemWriteM, 
  
    output wire  [4:0]   WriteRegM,writeRegMOut,
    output wire  [31:0]  ReadDataM,
    output wire  [31:0]  ALUOutM ,aluOutMOut

);


assign WriteRegM = WriteRegM_IN; 
assign ALUOutM      = ALUOutM_IN; 


Memory #(32, 512) Data_mem
(
.CLK (CLK), 
.RST(RST),
.RD(ReadDataM), 
.WD(WriteDataM), 
.A(ALUOutM_IN),
.WE(MemWriteM),
.bytes(storeM)
); 








endmodule





