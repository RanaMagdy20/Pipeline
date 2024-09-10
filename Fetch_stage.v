module Fetch_Satge (
    input  wire [31:0] PCF,
    input wire WE,
    output wire [31:0] RD, 
    output wire [31:0] PCPlus4F
     
);
assign WE =1'b1;
PCPlus #(32) PCPluss
(
.PC(PCF),
.PCPlus4(PCPlus4F)
);

Memory #(32, 512) instr_mem
(
.RD(RD), 
.A(PCF),
.WE(WE)
); 

endmodule
