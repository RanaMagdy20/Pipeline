module mux6to1 #(parameter WIDTH=32)
(
    input wire [WIDTH-1:0] in1,in2,in3,in4,in5,in6,
    input wire [2:0]sel,
    output reg [WIDTH-1:0] out
);
always @(*) begin
    case (sel) 
    'd0: out=in1;
    'd1: out=in2;
    'd2: out=in3;
    'd3: out=in4;
    'd4: out=in5;
    'd5: out=in6;
    default : out='d0;
    endcase
end
endmodule