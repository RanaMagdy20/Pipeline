module PCPlus #(parameter WIDTH = 32) 
(
input  wire  [WIDTH-1:0] PC,
output wire  [WIDTH-1:0] PCPlus4

);
 
assign PCPlus4= PC+'d4;

endmodule


