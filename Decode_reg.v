module Decode_Register (
    input  wire [31:0]  rd, pcPlus4F,
    input wire   CLK, en, CLR, RST,
    output  reg  [31:0]  instrD, pcPlus4D
);

always @(posedge CLK or negedge RST)
        begin
            if(!RST)
                begin
                    instrD   <=    32'b0;
                    pcPlus4D <=    32'b0;
                end
            else if (CLR & !en)
                begin
                    instrD   <=    32'b0;
                    pcPlus4D <=    32'b0;
                end
            else if(!en)
                begin
                    instrD   <=    rd;
                    pcPlus4D <=    pcPlus4F;
                end
        end
endmodule 