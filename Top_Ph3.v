module Top_Ph3(input CLK,
               input reset);
  
  
  wire StallF;
  wire StallD;
  wire StallE;
  wire StallM;
  wire FlushD;
  wire FlushE;
  wire FlushM;
  wire FlushW;
  wire SkipMem;
  wire [1:0] ForwardAE;
  wire [1:0] ForwardBE;
  wire RegWriteD;
  wire MemtoRegD;
  wire MemWriteD;
  wire MemWriteE;
  wire MemWriteM;
  wire [3:0] ALUControlD;
  wire ALUSrcD;
  wire RegDstD;
  wire BranchD;
  wire BranchND;
  wire [5:0] Op;
  wire [5:0] Funct;
  wire [4:0] RsD;
  wire [4:0] RtD;
  wire [4:0] RdD;
  wire [4:0] RsE;
  wire [4:0] RtE;
  wire [4:0] WriteRegE;
  wire [4:0] WriteRegM;
  wire [4:0] WriteRegW;
  wire MemtoRegE;
  wire MemtoRegM;
  wire RegWriteM;
  wire RegWriteW;
  wire PCSrcE;
  wire SignExt;
  wire CacheReady;
            
  DPath dpath1(CLK, reset, SignExt, StallF, StallD, StallE, StallM, FlushD, FlushE, FlushM, FlushW, SkipMem, ForwardAE, ForwardBE,
               RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, BranchD, BranchND,
               Op, Funct, RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW, MemtoRegE, MemtoRegM, RegWriteM,
               RegWriteW, MemWriteE, MemWriteM, PCSrcE, CacheReady);
 
  CU cu1(Op, Funct, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, BranchD, BranchND, SignExt);             
               
  HU hu1(CLK, reset, CacheReady, RsD, RtD, RdD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW, MemWriteD, MemWriteE, MemWriteM, MemtoRegD, MemtoRegE, MemtoRegM, RegDstD, RegWriteM, RegWriteW, PCSrcE,
         StallF, StallD, StallE, StallM, FlushD, FlushE, FlushM, FlushW, SkipMem, ForwardAE, ForwardBE); 
              
endmodule