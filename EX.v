module EX(input         RegDstE,
          input         ALUSrcE,
          input         SignExtE,
          input  [3:0]  ALUControlE,
          input         BranchE,
          input         BranchNE,
          input  [1:0]  ForwardAE,
          input  [1:0]  ForwardBE,
          input  [31:0] RD1E,
          input  [31:0] RD2E,
          input  [4:0]  RsE,
          input  [4:0]  RtE,
          input  [4:0]  RdE,
          input  [31:0] ExtImmE,
          input  [31:0] PCPlus4E,
          input  [31:0] ResultW,
          input  [31:0] ALUOutM,
          output        PCSrcE,
          output [31:0] ALUOutE,
          output [31:0] WriteDataE,
          output [4:0]  WriteRegE,
          output [31:0] PCBranchE);
          
  wire [31:0] SrcAE;
  wire [31:0] SrcBE;
  wire [31:0] MuxB;
  wire ZeroE;
  
  assign SrcAE = ForwardAE[1] ? (ForwardAE[0] ? 32'bx : ALUOutM) : (ForwardAE[0] ? ResultW : RD1E); 
  assign MuxB = ForwardBE[1] ? (ForwardBE[0] ? 32'bx : ALUOutM) : (ForwardBE[0] ? ResultW : RD2E);
  assign SrcBE = ALUSrcE ? ExtImmE : MuxB;
  assign WriteDataE = MuxB;

  assign WriteRegE = RegDstE ? RdE : RtE;
  assign PCBranchE = (ExtImmE << 2) + PCPlus4E;
    
  alu a1(.a(SrcAE), .b(SrcBE), .alucontrol(ALUControlE), .result(ALUOutE), .zero(ZeroE));
  
  assign PCSrcE = (BranchE & ZeroE) | (BranchNE & (!ZeroE));
  
endmodule
  
  