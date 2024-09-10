module mux3to1 #(parameter WIDTH=32)
(
    input wire [WIDTH-1:0] in1,in2,in3,
    input wire [1:0]sel,
    output reg [WIDTH-1:0] out
);
always @(*) begin
    case (sel) 
    'd0: out=in1;
    'd1: out=in2;
    'd2: out=in3;
    default : out='d0;
    endcase
end
endmodule