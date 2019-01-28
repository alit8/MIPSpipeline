module DE(input         CLK,
          input         RegWriteW,
          input         SignExt,
          input  [31:0] InstrD,
          input  [4:0]  WriteRegW,
          input  [31:0] ResultW,
          output [31:0] RD1D,
          output [31:0] RD2D,
          output [4:0]  RsD,
          output [4:0]  RtD,
          output [4:0]  RdD,
          output [31:0] ExtImmD);
          
  wire [4:0]  A1;
  wire [4:0]  A2;
  wire [4:0]  A3;
  wire        WE3;
  wire [31:0] WD3;
  wire [31:0] RD1;
  wire [31:0] RD2;
  
  assign A1 = InstrD[25:21];
  assign A2 = InstrD[20:16];
  assign A3 = WriteRegW;
  assign WE3 = RegWriteW;
  assign WD3 = ResultW;
  
  assign RsD = InstrD[25:21];
  assign RtD = InstrD[20:16];
  assign RdD = InstrD[15:11];

  regfile rf1(.clk(CLK), .we3(WE3), .ra1(A1), .ra2(A2), .wa3(A3), .wd3(WD3), .rd1(RD1), .rd2(RD2));

  assign RD1D = ((A1 == A3) & (A1 != 0) & WE3) ? WD3 : RD1;
  assign RD2D = ((A2 == A3) & (A2 != 0) & WE3) ? WD3 : RD2;

  assign ExtImmD = SignExt ? {{16{InstrD[15]}}, InstrD[15:0]} : {{16'd0}, InstrD[15:0]};
  
    
endmodule
  
  

    


