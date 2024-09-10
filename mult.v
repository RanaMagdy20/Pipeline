module mult #(parameter DATA_WIDTH=32)
(
    input wire [DATA_WIDTH-1:0]  A,B,
    input wire enable, sign,
    output reg [2*DATA_WIDTH-1:0] C
);

always @(*) begin
    if (enable) begin
        if(sign)
        C=$signed(A)*$signed(B);
        else  //unsigned
        C=A*B;
    end
    else begin
        C='d0;
        
    end
    
end

endmodule

