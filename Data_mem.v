module Memory # (parameter DATA_WIDTH=32, DEPTH=512)
(
    input wire CLK, RST,
    input wire WE,
    input wire [1:0] bytes,
    input wire [DATA_WIDTH-1:0] A, //address    
    //[$clog2(DEPTH)-1:0] A,
    input wire [DATA_WIDTH-1:0] WD,//write data 
    output wire [DATA_WIDTH-1:0] RD //read data
);

reg [7:0] mem [0:DEPTH-1] ;  //Byte addresable memory
integer i;
// read operation :

assign  RD = {mem[A+3],mem[A+2],mem[A+1],mem[A]};
 //assign RD = mem[A>>2];

//write operation
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        for(i=0; i<DEPTH ; i=i+1)
        mem[i] <= 'd0;
    end
        
 else if (WE) begin
    case(bytes)
    'd0 : {mem[A+3],mem[A+2],mem[A+1],mem[A]} = WD; //store word
    'd1 : mem[A]=WD[7:0] ;//store byte 
    'd2 :  {mem[A+1],mem[A]} = WD[15:0] ; //store half byte
    default : {mem[A+3],mem[A+2],mem[A+1],mem[A]} = WD;
 endcase
 end
    
end
endmodule


