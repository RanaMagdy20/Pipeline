module div #(parameter DATA_WIDTH=32)
(
    input wire [DATA_WIDTH-1:0]  A,B,
    input wire enable, sign,
//output wire div_by_zero,
    output reg [2*DATA_WIDTH-1:0] C
);
//assign div_by_zero = (SrcB=='d0) ? 1'b1 :1'b0;

always @(*) begin
    if (enable) begin
        if(sign)
        C=$signed(A)/$signed(B);
        else  //unsigned
        C=A/B;
    end
    else begin
        C='d0;
        
    end
    
end


///// at top output div by zero goes to cpo
endmodule

