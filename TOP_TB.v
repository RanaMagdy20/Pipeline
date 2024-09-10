module TOP_TB ();
parameter TCLK=10;
parameter DATA_WIDTH=32; //, INSTR_MEM_DEPTH=32, Data_MEM_DEPTH=32, REG_DEPTH=32;
reg CLK,RST,WE;
//reg [DATA_WIDTH-1:0] INSTRUCTIONS;
integer i;
//clock generation:
always #(TCLK/2) CLK=~CLK;

//INSTantiation:

TOP #(.DATA_WIDTH(DATA_WIDTH)) DUT 
(
.CLK(CLK),
.WE(WE),
.RST(RST)//,
//.INSTRUCTIONS(INSTRUCTIONS)
);

initial begin
  //load instructions:
    $readmemh("mem1.txt",DUT.FS.instr_mem.mem);

  // load registers:
  for (i=0; i<32;i=i+1)
 DUT.DS.RF.mem[i] = i;

    CLK=0;
    RST=1;
    WE=1;
    #TCLK;
    RST=0;
    #TCLK;
    //WE=1;
    RST=1;
    #1000 $stop;

end
endmodule