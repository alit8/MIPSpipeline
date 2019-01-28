module DPath(input            CLK,
             input            reset,
             input            SignExt,
             input            StallF,
             input            StallD,
             input            StallE,
             input            StallM,
             input            FlushD,
             input            FlushE,
             input            FlushM,
             input            FlushW,
             input            SkipMem,
             input      [1:0] ForwardAE,
             input      [1:0] ForwardBE,
             input            RegWriteD,
             input            MemtoRegD,
             input            MemWriteD,
             input      [3:0] ALUControlD,
             input            ALUSrcD,
             input            RegDstD,
             input            BranchD,
             input            BranchND,
             output     [5:0] Op,
             output     [5:0] Funct,
             output     [4:0] RsD,
             output     [4:0] RtD,
             output reg [4:0] RsE,
             output reg [4:0] RtE,
             output     [4:0] WriteRegE,
             output reg [4:0] WriteRegM,
             output reg [4:0] WriteRegW,
             output reg       MemtoRegE,
             output reg       MemtoRegM,
             output reg       RegWriteM,
             output reg       RegWriteW,
             output reg       MemWriteE,
             output reg       MemWriteM,
             output           PCSrcE,
             output           CacheReady);
             
  wire PCSrc;
  wire [31:0] PCBranch;
  wire RegWrite;
  wire [4:0] WriteReg;
  wire [31:0] Result;
  wire [31:0] ALUOut;
  
  wire [31:0] InstrF;
  wire [31:0] PCPlus4F;
  wire [31:0] RD1D;
  wire [31:0] RD2D;
  wire [4:0] RdD;
  wire [31:0] ExtImmD;
  wire [31:0] ALUOutE;
  wire [31:0] WriteDataE;
  wire [31:0] PCBranchE;
  wire [31:0] ReadDataM;
  wire [31:0] ResultW;
  wire [31:0] RD1;
  wire [31:0] RD2;
  
  reg [31:0] InstrD;
  reg [31:0] PCPlus4D;
  reg [31:0] RD1E;
  reg [31:0] RD2E;
  reg [4:0]  RdE;
  reg [31:0] ExtImmE;
  reg [31:0] PCPlus4E;
  reg [31:0] ALUOutM;
  reg [31:0] WriteDataM;
  reg [31:0] ReadDataW;
  reg [31:0] ALUOutW;
  
  reg RegWriteE, ALUSrcE, RegDstE, BranchE, BranchNE,
      MemtoRegW;
  
  reg [3:0] ALUControlE;
  
  assign PCSrc = PCSrcE;
  assign WriteReg = WriteRegW;
  assign RegWrite = RegWriteW;
  assign PCBranch = PCBranchE;
  assign Result = ResultW;
  assign RD1D = RD1;
  assign RD2D = RD2;
  
  assign Op = InstrD[31:26];
  assign Funct = InstrD[5:0];
  
  IF if1(CLK, reset, PCSrc, StallF, PCBranch, InstrF, PCPlus4F);
  DE de1(CLK, RegWrite, SignExt, InstrD, WriteReg, Result, RD1, RD2, RsD, RtD, RdD, ExtImmD);
  EX ex1(RegDstE, ALUSrcE, SignExtE, ALUControlE, BranchE, BranchNE, ForwardAE, ForwardBE, RD1E, RD2E, RsE, RtE, RdE, 
        ExtImmE, PCPlus4E, ResultW, ALUOutM, PCSrcE, ALUOutE, WriteDataE, WriteRegE, PCBranchE);
  ME me1(CLK, reset, MemWriteM, MemtoRegM, ALUOutM, WriteDataM, ReadDataM, CacheReady);
  WB wb1(MemtoRegW, ReadDataW, ALUOutW, ResultW);    
  
  always @(posedge CLK)
  begin
    
    if (reset | FlushD)
      begin
        InstrD <= 0;
        PCPlus4D <= 0;
      end
    else if (StallD)
      begin
        InstrD <= InstrD;
        PCPlus4D <= PCPlus4D;
      end
    else
      begin
        InstrD <= InstrF;
        PCPlus4D <= PCPlus4F;
      end

    if (reset | FlushE)
      begin
        RD1E <= 0;
				RD2E <= 0;
				RsE <= 0;
				RtE <= 0;
				RdE <= 0;
				ExtImmE <= 0;
				PCPlus4E <= 0;
			
				RegWriteE <= 0;
				MemtoRegE <= 0;
				MemWriteE <= 0;
				ALUControlE <= 0;
				ALUSrcE <= 0;
				RegDstE <= 0;
				BranchE <= 0;
				BranchNE <= 0;
      end
    else if (StallE)
      begin
        RD1E <= RD1E;
				RD2E <= RD2E;
				RsE <= RsE;
				RtE <= RtE;
				RdE <= RdE;
				ExtImmE <= ExtImmE;
				PCPlus4E <= PCPlus4E;
			
				RegWriteE <= RegWriteE;
				MemtoRegE <= MemtoRegE;
				MemWriteE <= MemWriteE;
				ALUControlE <= ALUControlE;
				ALUSrcE <= ALUSrcE;
				RegDstE <= RegDstE;
				BranchE <= BranchE;
				BranchNE <= BranchNE;
      end
    else
      begin
        RD1E <= RD1;
				RD2E <= RD2;
				RsE <= RsD;
				RtE <= RtD;
				RdE <= RdD;
				ExtImmE <= ExtImmD;
				PCPlus4E <= PCPlus4D;
			
				RegWriteE <= RegWriteD;
				MemtoRegE <= MemtoRegD;
				MemWriteE <= MemWriteD;
				ALUControlE <= ALUControlD;
				ALUSrcE <= ALUSrcD;
				RegDstE <= RegDstD;
				BranchE <= BranchD;
				BranchNE <= BranchND;
      end
    
    if (reset | FlushM)
      begin
        ALUOutM <= 0;
		    WriteRegM <= 0;
		    WriteDataM <= 0;
		    
		    RegWriteM <= 0;
	   	  MemtoRegM <= 0;
		    MemWriteM <= 0;
		  end
		else if (StallM)
		  begin
		    ALUOutM <= ALUOutM;
	     	WriteRegM <= WriteRegM;
	     	WriteDataM <= WriteDataM;
	     	
	     	RegWriteM <= RegWriteM;
		    MemtoRegM <= MemtoRegM;
		    MemWriteM <= MemWriteM;
		  end
		else if (~SkipMem)
		  begin
		    ALUOutM <= ALUOutE;
	     	WriteRegM <= WriteRegE;
	     	WriteDataM <= WriteDataE;
	     	
	     	RegWriteM <= RegWriteE;
		    MemtoRegM <= MemtoRegE;
		    MemWriteM <= MemWriteE;
		  end
    
    if (reset | FlushW)
      begin
   		   ReadDataW <= 0;
		    ALUOutW <= 0;
	     	WriteRegW <= 0;
 
    	 		RegWriteW <= 0;
	     	MemtoRegW <= 0;      
	   	end
	  else if (SkipMem)
	    begin
	      ReadDataW <= 'dx;
		    ALUOutW <= ALUOutE;
		    WriteRegW <= WriteRegE;
		    
		    RegWriteW <= RegWriteE;
	     	MemtoRegW <= MemtoRegE;
	    end
	  else
	    begin	 	
		    ReadDataW <= ReadDataM;
		    ALUOutW <= ALUOutM;
		    WriteRegW <= WriteRegM;
		    
		    RegWriteW <= RegWriteM;
	     	MemtoRegW <= MemtoRegM;
	    end  
    
  end
              
endmodule       
             
