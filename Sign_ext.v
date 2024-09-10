module Sign_Ext # (parameter  DATA_WIDTH=32)
(
    input wire [15:0] instr_Imm,
    output reg [DATA_WIDTH-1:0] sign_Imm
);

wire instr_MSB;
assign instr_MSB = instr_Imm[15];
always @(*) begin
    sign_Imm = {{16{instr_MSB}},instr_Imm};
end
endmodule
    
