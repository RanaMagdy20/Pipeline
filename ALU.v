module ALU # (parameter DATA_WIDTH =32)
(
    input wire [DATA_WIDTH-1:0] SrcA,SrcB,
    input wire [4:0] shamt,
    input wire [4:0] ALU_CTRL,
    output wire Zero, //arith_overflow,
    output reg [DATA_WIDTH-1:0] ALU_Result 
);
always @ (*)
begin
    case (ALU_CTRL)
    'd0 : ALU_Result = SrcA & SrcB; //and
    'd1 : ALU_Result = SrcA | SrcB; //or
    'd2 : ALU_Result = SrcA + SrcB; //add,addu
    'd3 : ALU_Result = SrcA ^ SrcB; //xor
    'd6 : ALU_Result = $signed(SrcA) - $signed(SrcB); //signed sub 
    'd7 : ALU_Result = ($signed(SrcA) < $signed(SrcB))? 1'b1 : 1'b0; //slt
    'd8 : ALU_Result = (SrcA < SrcB) ? 1'b1 : 1'b0; //sltu
    'd9 : ALU_Result = ~(SrcA | SrcB); //nor
    'd10 : ALU_Result = SrcA - SrcB; //unsigned sub
    'd11 : ALU_Result = SrcB << shamt;//sll
    'd12 : ALU_Result = SrcB >> shamt;//srl
    'd13 : ALU_Result = $signed(SrcB) >>> shamt;//sra
    'd14 : ALU_Result = SrcB << SrcA[4:0];//sllv
    'd15 : ALU_Result = SrcB >> SrcA[4:0];//srlv
    'd4  : ALU_Result = $signed(SrcB) >>> SrcA[4:0];//srav
    'd16 : ALU_Result = (SrcA [31] ==1 || (~| SrcA)) ? 1:0; //blez
    'd17 : ALU_Result = (SrcA [31] ==0 && (|SrcA)) ? 1:0; //bgtz
    'd18 : ALU_Result = (SrcA [31] ==1 ) ? 1: (SrcA [31] ==0 || (~| SrcA)) ? 1 : 0; //bltz ,bgez


    default : ALU_Result = SrcA;
endcase
end

assign  Zero = ~| ALU_Result ;
//assign arith_overflow = ( ALU_CTRL=='d2 && (~(SrcA[31] ^ SrcB[31]))  && ( ALU_Result[31] !=SrcA[31] )  )  || 
                       // ( ALU_CTRL=='d6 &&  (SrcA[31] ^ SrcB[31])  && ( ALU_Result[31] !=SrcA[31] )  )  ? 1'b1 : 1'b0;

//at top arithoverflow go to cop0

endmodule
 