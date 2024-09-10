module GP_regs #(parameter DATA_WIDTH=32) 
(
    input wire CLK , RST,
    input wire [DATA_WIDTH-1:0] D1,D2,
    output wire [DATA_WIDTH-1:0] HI_out, LO_out

);

reg [DATA_WIDTH-1:0] HI ,LO;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        HI<='d0;
        LO<='d0;
    end
    else begin
        HI<=D1;
        LO<=D2;
    end
end

assign HI_out=HI;
assign LO_out=LO;
endmodule



