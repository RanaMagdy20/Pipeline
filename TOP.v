module TOP #(parameter DATA_WIDTH=32) //INSTR_MEM_DEPTH=512, Data_MEM_DEPTH=512, REG_DEPTH=32)
(
    input wire CLK,WE,RST
  //  input wire [DATA_WIDTH-1:0] INSTRUCTIONS,
   //output wire [DATA_WIDTH-1:0] Result

);


wire [DATA_WIDTH-1:0] PCF, PCBranchD, PCPlus4F,PC_next,PCJumpD,next,prog_counter,
                       PCPlus4D; //new

//wire [DATA_WIDTH-1:0] rd; //////new

wire [DATA_WIDTH-1:0] Result,Data_to_RF,Data_to_RF_1,final_Result;
wire [DATA_WIDTH-1:0] sign_Imm;
//wire [DATA_WIDTH-1:0] ALU_Result;
wire [DATA_WIDTH-1:0] WriteData,RD2, ReadData ;
wire [DATA_WIDTH-1:0] Instr ,instrD;
wire [DATA_WIDTH-1:0] SrcA,SrcB;
wire Jump,Branch,MemtoReg, MemWrite, RegDst, RegWrite,jr,jalr;
//wire bne;
wire [2:0] load;
wire [1:0] store, storeE,storeM, MultoRF;
wire [4:0] ALUControl;
wire [4:0]WriteReg; //$rt , $rd
wire Zero, PCSrc_beq, PCSrc_bne, PCSrc_blez_bgtz, PCSrc_bltz_bgez, PCSrcD ;
wire[1:0] ALUSrc , aluSrcE;
//HI_LO:
wire [1:0] multiply,divide,HI_sel,LO_sel;
wire [2*DATA_WIDTH-1:0] mult_result,div_result;
wire [DATA_WIDTH-1:0] HI_out,LO_out,HI_IN,LO_IN;


wire [4:0] shamtD,shamtE;
wire [15:0] immE,immD;


wire  [DATA_WIDTH-1:0]  readDataM, readDataW, aluOutW;
wire  memWriteM , memToRegW;
wire [DATA_WIDTH-1:0]  resultW, aluOutMOut, aluOutMIn, aluOutM, writeDataM;
wire [DATA_WIDTH-1:0] rd1D, rd2D, signImmD, signImmE;
wire stallD, stallF, flushE;
wire regWriteM, memToRegM, regWriteE, memToRegE, regWriteW;
wire [4:0] writeRegE, writeRegMOut, writeRegW, rsE, rsD, rtE, rtD, rdD, rdE,
          writeRegWIn, writeRegMIn, writeRegM ;
wire forwardAD, forwardBD;
wire   [1:0]  forwardAE, forwardBE;
wire memWriteE, regDstE;

wire  [1:0]  aluControlE;
wire [DATA_WIDTH-1:0]  rd1E, rd2E, writeDataE, aluOutE;
wire equalD, clearD;

//assign PCJumpD = {PCPlus4F[31:28],{Instr[25:0]<<2}}; ///////new
//assign PCPlus4F= PCF+'d4; //new
//assign PCBranchD= (sign_Imm<<2) + PCPlus4F; //new
assign PCSrc_beq =Branch && equalD;
assign PCSrc_bne=Branch && !equalD;
assign PCSrc_blez_bgtz= Branch && aluOutE;
//assign PCSrc_bltz_bgez = Branch && ( ((|aluOutE) && (&Instr[20:16])) || ((|aluOutE) && (~|Instr[20:16])) );
assign PCSrc_bltz_bgez = (Branch &&  (|aluOutMOut) && (&writeRegM)) || (Branch && (|aluOutMOut) && (~|writeRegM)) ? 1'b1 : 1'b0;



//new
assign PCSrcD = PCSrc_beq || PCSrc_bne || PCSrc_blez_bgtz || PCSrc_bltz_bgez ;

//new


Hazard_Unit HU
(
    .regWriteW(regWriteW),
    .regWriteM(regWriteM), 
    .memToRegM(memToRegM), 
    .regWriteE(regWriteE), 
    .memToRegE(memToRegE),
    .writeRegE(writeRegE),
    .jumpD(Jump),// 
    .branchD(Branch),//
    .writeRegM(writeRegMOut), 
    .writeRegW(writeRegW), 
    .rsE(rsE), 
    .rsD(rsD), 
    .rtE(rtE), 
    .rtD(rtD),
    .stallD(stallD), 
    .stallF(stallF), 
    .flushE(flushE),
    .forwardAD(forwardAD), 
    .forwardBD(forwardBD),
    .forwardAE(forwardAE), 
    .forwardBE(forwardBE)
);


mux2to1#(.WIDTH(DATA_WIDTH)) MUXtoBranch (
.in1(PCPlus4F),
.in2(PCBranchD),
.sel(PCSrcD),
.out(next)
);
mux2to1 #(.WIDTH(DATA_WIDTH)) MUXtoJump (
.in1(next),
.in2(PCJumpD),
.sel(Jump),
.out(PC_next)
);

mux2to1 #(.WIDTH(DATA_WIDTH)) MUXtoJr (
.in1(PC_next),
.in2(rd1D), ///////////////////////////[rs]
.sel(jr),
.out(prog_counter)
);


PC_reg #(.DATA_WIDTH(DATA_WIDTH)) PC_flipflop
(
.CLK(CLK),
.RST(RST),
.EN(stallF), //from hazard unit
.prog_counter(prog_counter),
.PC(PCF) 
);


Fetch_Satge FS 
(
.RD(Instr),
.WE(WE),
.PCPlus4F(PCPlus4F),
.PCF(PCF)
);

Decode_Register DR
(
.rd(Instr),
.pcPlus4F(PCPlus4F),
.CLK(CLK),
.RST(RST),
.en(stallD),
.CLR(clearD),
.instrD(instrD),
.pcPlus4D(PCPlus4D)
);



Decode_Stage DS
(.RegWriteW(regWriteW),
.InstrD(instrD),
.multiply(multiply),
.divide(divide),
.mult_result(mult_result),
.div_result(div_result),
//.ResultW(resultW), modified
.ResultW(Data_to_RF),
.ALUOutM(aluOutMOut),
.PCPlus4D(PCPlus4D),
.WriteRegW(writeRegW),
.forwardAD(forwardAD),
.forwardBD(forwardBD),
.CLK(CLK),//
.RST(RST),//
//.Opcode(instrD[31:26]),//
//.func(instrD[5:0]),//
.rd1D(rd1D),
.rd2D(rd2D),
.signImmD(signImmD),
.PCBranchD(PCBranchD),
.PCJumpD(PCJumpD),
.rsD(rsD),
.rtD(rtD),
.rdE(rdD),
.shamtD(shamtD),
.immD(immD),
.EqualD(equalD)
);
Execute_Register ER
(.regWriteE(regWriteE),
.memToRegE(memToRegE),
.storeE(storeE),
 .memWriteE(memWriteE),
.aluControlE(aluControlE),
.aluSrcE(aluSrcE),
 .regDstE(regDstE),
 .rd1E(rd1E),
 .rd2E(rd2E),
 .rsE(rsE),
 .rtE(rtE),
 .rdE(rdE),
 .shamtE(shamtE),
.signImmE(signImmE),
.immE(immE),
.regWriteD(RegWrite),
 .memToRegD(MemtoReg),
 .memWriteD(MemWrite),
 .storeD(store),
 .aluControlD(ALUControl),
.aluSrcD(ALUSrc),
 .regDstD(RegDst),
.rd1D(rd1D),
 .rd2D(rd2D),
 .rsD(rsD),
.rtD(rtD),
.rdD(rdD),
.shamtD(shamtD),
.immD(immD),
 .signImmD(signImmD),
 .CLK(CLK),
.RST(RST),
.CLR(flushE)
);

Execute_Stage ES
(.RegDstE(regDstE), 
.ALUSrcE(aluSrcE),
.shamtE(shamtE),
.ALUControlE(aluControlE),
.Rd1D(rd1E),
.Rd2D(rd2E),
.RsE(rsE),
.RtE(rtE),
.RdE(rdE),
.immE(immE),
.signImmE(signImmE),
.ALUOutMOut(aluOutMOut), 
.ResultW(resultW),
.ForwardAE(forwardAE),
.ForwardBE(forwardBE),
.RsEtoHazardUnit(rsE), 
.RtEtoHazardUnit(rtE),
.WriteRegE(writeRegE),
.WriteDataE(writeDataE), 
.ALUOutE(aluOutE)
);

Memory_Register MR
(.regWriteE(regWriteE),
.memToRegE(memToRegE),
.storeE(storeE),
.memWriteE(memWriteE),
.aluOutE(aluOutE),
.writeRegE(writeRegE),
.writeDataE(writeDataE),
.CLK(CLK),
.RST(RST),
.regWriteM(regWriteM),
.storeM(storeM),
.memToRegM(memToRegM),
.memWriteM(memWriteM),
.aluOutM(aluOutMIn),
.writeDataM(writeDataM),
.writeRegM(writeRegMIn)
);

Memory_Stage MS
(
.writeRegMOut(writeRegMOut),
.aluOutMOut(aluOutMOut),
.ReadDataM(readDataM),
.storeM(storeM),
.ALUOutM(aluOutM),
.WriteRegM(writeRegM),
.WriteRegM_IN(writeRegMIn),
.ALUOutM_IN(aluOutMIn),
.WriteDataM(writeDataM),
.MemWriteM(memWriteM),
.CLK(CLK),
.RST(RST)
);

WriteBack_Register WBR
(
.CLK(CLK),
.RST(RST),
.regWriteM(regWriteM),
.memToRegM(memToRegM),
.readDataM(readDataM),
.aluOutM(aluOutM),
.writeRegM(writeRegM),
.regWriteW(regWriteW),
.memToRegW(memToRegW),
.readDataW(readDataW),
.aluOutW(aluOutW),
.writeRegW(writeRegWIn)
);

WriteBack_Stage WBS
(.ResultW(resultW),
.WriteRegW_Out(writeRegW),
.MemtoRegW(memToRegW),
.ReadDataW(readDataW),
.ALUOutW(aluOutW),
.WriteRegW_IN(writeRegWIn)
);





mux6to1 #(.WIDTH(DATA_WIDTH)) MUXtoload (
.in1(resultW),
.in2({{24{resultW[7]}},resultW[7:0]}), //sign extend
.in3({{16{resultW[7]}},resultW[15:0]}), //sign extend
.in4({24'd0,resultW[7:0]}), //zero ext
.in5({16'd0,resultW[15:0]}) ,//zero ext
.in6({immE,16'b0}),//lui ///////bypass to WB stage or remain in E???????? 
.sel(load),
.out(final_Result) //to RF
);


mux2to1 #(.WIDTH(DATA_WIDTH)) MUXtoJalr (
.in1(final_Result),
.in2(PCPlus4F),
.sel(jalr),
.out(Data_to_RF_1)
);


CU control_unit
(.Opcode(Instr[31:26]),
.Funct(Instr[5:0]),
.MemtoReg(MemtoReg),
.MemWrite(MemWrite), 
.Branch(Branch), 
.ALUSrc(ALUSrc), 
.RegDst(RegDst), 
.RegWrite(RegWrite), 
.Jump(Jump),
.jr(jr),
.jalr(jalr),
.multiply(multiply),
.divide(divide),
.LO_sel(LO_sel),
.HI_sel(HI_sel),
//.bne(bne),
.load(load),
.store(store),
.MultoRF(MultoRF),
.ALUControl(ALUControl) 
);


mux3to1#(.WIDTH(DATA_WIDTH)) MUXtoHI (
.in1(SrcA), //mthi
.in2(mult_result[63:32]), //rs x rt
.in3(div_result[63:32]),
.sel(HI_sel),
.out(HI_IN)
);
mux3to1#(.WIDTH(DATA_WIDTH)) MUXtoLO (
.in1(SrcA), //mtlo
.in2(mult_result[31:0]), //[rs] x [rt]
.in3(div_result[31:0]), //[rs]/[rt]
.sel(LO_sel),
.out(LO_IN)
);

mux4to1 #(.WIDTH(DATA_WIDTH)) MUXtoRF (
.in1(Data_to_RF_1),  //not multiplication nor division
.in2(mult_result[31:0]), //mul result
.in3(HI_out),  //mfhi
.in4(LO_out),  //mflo
.sel(MultoRF),
.out(Data_to_RF)
);

GP_regs #(.DATA_WIDTH(DATA_WIDTH)) HI_LO
(
.CLK(CLK),
.RST(RST),
.D1(HI_IN),
.D2(LO_IN),
.HI_out(HI_out),
.LO_out(LO_out)
);











endmodule




/*


mux2to1#(.WIDTH(DATA_WIDTH)) MUX0 (
.in1(),
.in2(),
.sel(),
.out()
);



*/