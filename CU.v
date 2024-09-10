module CU 
(   input wire [5:0] Opcode,Funct, 
   // input wire external_interrupt,//externally as an input
    // wire div_by_zero,//from divider
    output reg MemtoReg, MemWrite, Branch, RegDst, RegWrite, Jump,//bne,
    output reg jr,jalr,
   // output reg Break,Syscall,mfc0,mtc0; ////new
    output reg [2:0] load,
    output reg [1:0]multiply,divide,HI_sel,LO_sel,  ALUSrc, store,MultoRF,
    output wire [31:0] Cause,
    output reg [4:0] ALUControl 
);

reg [1:0] ALUOp;



/*
//////////////exception :
assign Break = ((Opcode == 6'd0) && (Funct==6'b001101) ) ?  1'b1 : 1'b0;
assign Syscall = ((Opcode == 6'd0) && Funct==6'b001100 ) ?  1'b1 : 1'b0;
assign mfc0= ((Opcode== 6'b010000 ) && (instrD[25:21]==5'd0)) ? 1'b1 : 1'b0;
assign mtc0= ((Opcode== 6'b010000 ) && (instrD[25:21]==5'd4)) ? 1'b1 : 1'b0;

*/








//Main Decoder:
always @(*) begin
    Branch=1'b0;
    Jump=1'b0;
   // multiply='b00;
    RegWrite=1'b0;
    RegDst=1'b0; //rt
    ALUSrc='b00;
    MemWrite=1'b0;
    MemtoReg=1'b0;
    ALUOp=2'b00;
   // bne=1'b0;
   // blez=1'b0;
    load='d0;
    store='d0;
    
    


    case (Opcode) 
    6'b000_000 : begin //R_type
        RegWrite=1'b1;
        RegDst=1'b1;
        ALUOp=2'b10;
    end
    6'b100_011: begin //lw
        RegWrite=1'b1;
        ALUSrc='b01;
        MemtoReg=1'b1;
        ALUOp=2'b00;
        load='d0;
    end 
    6'b100_001: begin //lh
        RegWrite=1'b1;
        ALUSrc='b01; //sign_ext
        MemtoReg=1'b1;
        ALUOp=2'b00; //add
        load='d2; //sign_ext(Result[15:0])
    end 
    6'b100_000: begin //lb
        RegWrite=1'b1;
        ALUSrc='b01; //sign_ext
        MemtoReg=1'b1;
        ALUOp=2'b00; //add
        load='d1; //sign_ext(Result[7:0])
    end 
     6'b100_100: begin //lbu
        RegWrite=1'b1;
        ALUSrc='b01; //sign_ext
        MemtoReg=1'b1;
        ALUOp=2'b00; //add
        load='d3; //zero_ext(Result[7:0])
    end        
    6'b100_001: begin //lhu
        RegWrite=1'b1;
        ALUSrc='b01; //sign_ext
        MemtoReg=1'b1;
        ALUOp=2'b00; //add
        load='d4; //zero_ext(Result[15:0])
    end 
    6'd001_111: begin //lui
      RegWrite=1'b1;
      load='d5;
    end  
    6'b101_011: begin //sw
        ALUSrc='b01;
        MemWrite=1'b1;
        ALUOp=2'b00;
        store=2'b00;
    end     
    6'b101_000: begin //sb
        ALUSrc='b01;
        MemWrite=1'b1;
        ALUOp=2'b00;
        store=2'b01;
    end     
    6'b101_001: begin //sh
        ALUSrc='b01;
        MemWrite=1'b1;
        ALUOp=2'b00;
        store=2'b10;
    end     
    
     
    6'b000_100: begin //beq
        Branch=1'b1;
        ALUOp=2'b01;
    end 
    6'b000_101: begin //bne
        Branch=1'b1;
        ALUOp=2'b01;
       // bne=1'b1;
    end 
    6'b000_110: begin //blez
    
        Branch=1'b1;
        ALUOp=2'b11;
    end
    6'b000_111: begin //bgtz
    
        Branch=1'b1;
        ALUOp=2'b11;
    end
    6'b000_001: begin //bltz ,bgez
    
        Branch=1'b1;
        ALUOp=2'b11;
    end

     
    
    6'b001_000: begin //addi
        RegWrite=1'b1;
        ALUSrc='b01;
        ALUOp=2'b00;
    end 
     6'b001_001: begin //addiu
        RegWrite=1'b1;
        ALUSrc='b01;
        ALUOp=2'b00;
    end   
    6'b000_010: begin //j
        ALUOp=2'b00;
        Jump=1'b1;
    end 
    6'b000_011: begin //jal
        ALUOp=2'b00;
        Jump=1'b1;
    end        
    6'b011_100: begin //mul
       // multiply=2'b11;
        RegDst=1'b1;
        RegWrite=1'b1;
    end
    6'b001_010: begin //slti
      RegWrite=1'b1;
      ALUOp=2'b10;
      ALUSrc='b01; //sign_imm
      //RegDst=1'b0; //store at [rt]
    end
    6'd001_100: begin //andi
      RegWrite=1'b1;
      ALUOp=2'b10;
      ALUSrc='b10; //zero extend
    end
    6'd001_101: begin //ori
      RegWrite=1'b1;
      ALUOp=2'b10;
      ALUSrc='b10; //zero extend
    end   
    6'd001_101: begin //xori
      RegWrite=1'b1;
      ALUOp=2'b10;
      ALUSrc='b10; //zero extend
    end   
 
    
        

    default : begin
        RegWrite=1'b0;
        RegDst=1'b0;
        ALUSrc='b00;
        MemWrite=1'b0;
        MemtoReg=1'b0;
        ALUOp=2'b00;
       // multiply=2'b00;
        Jump=1'b0;
        Branch=1'b0;
    end

    endcase 
end
//
//HI_LO_input_data:
//multiplication & division :
always @(*) begin
    multiply='d0;
    divide='d0;
    HI_sel=2'b11; 
    LO_sel=2'b11;
    case(Opcode)
    6'b011_100:begin //mul
    multiply=2'b11;
    end
    6'b000_000 : begin //multiply in R-type 
   if({ALUOp,Funct}==8'b10_011000) //mult
   begin 
        multiply=2'b11; //enable,signed 
        HI_sel=2'b01; //mult_result
        LO_sel=2'b01; //mult_result
    end
    else if ({ALUOp,Funct}== 8'b10_011001) //multu
   begin 
        multiply= 2'b10;
        HI_sel=2'b01; //mult_result
        LO_sel=2'b01; //mult_result
    end
    else if ({ALUOp,Funct}== 8'b10_011010) begin //div
        divide=2'b11;
        HI_sel=2'b10; //div_result
        LO_sel=2'b10; //div_result
    end
    else if ({ALUOp,Funct}==8'b10_011011) begin //divu
        divide=2'b10;
        HI_sel=2'b10;  //div_result
        LO_sel=2'b10; //div_result
     end
    else if ({ALUOp,Funct}==8'b10_010001 )begin //mthi
        HI_sel=2'b00; 
    end
    else if ({ALUOp,Funct}==8'b10_010011 ) begin //mtlo
        LO_sel=2'b00;
    end
    else begin
    multiply=2'b00;
    divide=2'b00;
    HI_sel=2'b11; //invalid case
    LO_sel=2'b11; //invalid case
    end
    end

    default:begin
    multiply=2'b00;
    divide=2'b00;
    HI_sel=2'b11; //invalid case
    LO_sel=2'b11; //invalid case
    end
endcase
end
always @(*) begin
    case (Opcode)
    6'b011_100:  MultoRF='d1;
    6'b000_000: begin
        if({ALUOp,Funct}==8'b10_010000) //mfhi
        MultoRF='d2;
        else if ({ALUOp,Funct}==8'b10_010010) 
        MultoRF='d3;
        else 
        MultoRF='d0;
    end
    default : MultoRF='d0;
    endcase

end








//jr, jalr => R-type , jal => j-type
always @(*) begin
if (Opcode==6'b000_011) begin //jal
    jr=1'b0;
    jalr=1'b1;
end
else
case ({ALUOp,Funct} )
8'b10_001000 : begin //jr
    jr = 1'b1;
    jalr =1'b0;
end
8'b10_001001 : begin //jalr
    jr = 1'b1;
    jalr = 1'b1;
end
default: begin
    jr= 1'b0;
    jalr =1'b0;
end
endcase
end

//ALU Decoder:
always @(*) begin

if (Opcode ==  6'b001_010) //slti
ALUControl = 5'b00111;

else if (Opcode ==  6'b001_011) //sltiu
ALUControl = 5'b01000;

else if (Opcode == 6'b001_100) //andi
ALUControl = 5'b00000;

else if (Opcode == 6'b001_101) //ori
ALUControl = 5'b00001;

else if (Opcode == 6'b001_110) //xori
ALUControl = 5'b0011;
//branch:
else if (Opcode == 6'b000_110) //blez
ALUControl = 5'b10000;
else if (Opcode == 6'b000_110) //bgtz
ALUControl = 5'b10001;
else if (Opcode == 6'b000_001) //bltz ,bgez
ALUControl = 5'b10010;


else begin 
casex ({ALUOp,Funct})
8'b01_xxxxxx: ALUControl = 5'b00110; //sub
8'b00_xxxxxx: ALUControl = 5'b00010; //add
//R-type: (ALU):
8'b10_100100: ALUControl = 5'b00000; //and
8'b10_100101: ALUControl = 5'b00001; //or
8'b10_10000x: ALUControl = 5'b00010; //add , addu
8'b10_100110: ALUControl = 5'b00011; //xor
8'b10_100010: ALUControl = 5'b00110; //sub 
8'b10_101010: ALUControl = 5'b00111; //slt
8'b10_101011: ALUControl = 5'b01000; //sltu
8'b10_100111: ALUControl = 5'b01001; //nor
8'b10_100011: ALUControl = 5'b01010;// subu
8'b10_000000: ALUControl = 5'b01011; //sll
8'b10_000010: ALUControl = 5'b01100; //srl
8'b10_000011: ALUControl = 5'b01101; //sra
8'b10_000100: ALUControl = 5'b01110; //sllv
8'b10_000110: ALUControl = 5'b01111; //srlv
8'b10_000111: ALUControl = 5'b00100; //srlv
default: ALUControl = 5'b00010; //add
endcase
end

end







endmodule