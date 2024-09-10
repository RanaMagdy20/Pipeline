module Register_File # (parameter WIDTH=32 , DEPTH=32)
(
    input wire CLK, RST, 
    input wire WE,
    input wire [4:0] A1, A2, A3, //adrresses
    input wire [WIDTH-1:0] WD3,//write data 
    output reg [WIDTH-1:0] RD1,RD2 //read data
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
integer  i;
always @(negedge CLK or negedge RST ) begin
    if (!RST) begin
        for (i=0 ; i<DEPTH ; i=i+1)
        mem [i] <= {32{1'b0}}; 
    end
    else if (WE) 
        mem[A3] <= WD3; //rt or rd
end



 assign RD1=(A1 != 'd0) ? mem[A1]:'d0; // rs
 assign RD2=(A2 != 'd0) ? mem[A2]:'d0; // rt



endmodule

