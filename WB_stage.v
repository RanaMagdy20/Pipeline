module WriteBack_Stage (
    
    input  wire MemtoRegW, 
    input  wire   [31:0]   ReadDataW, ALUOutW,
    input  wire   [4:0]    WriteRegW_IN,
    output wire   [31:0]  ResultW, 
    output wire   [4:0]   WriteRegW_Out
 
);

assign WriteRegW_Out = WriteRegW_IN; 

mux2to1 #(32) MUX1
(
.in1 (ALUOutW), 
.in2 (ReadDataW), 
.sel (MemtoRegW),
.out (ResultW)

);

endmodule