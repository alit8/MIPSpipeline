module IF(input         CLK,
          input         reset,
          input         PCSrcE,
          input         StallF,
          input  [31:0] PCBranchM,
          output [31:0] InstrF,
          output [31:0] PCPlus4F);
          
  wire [31:0] PC_;
  reg  [31:0] PCF;
  
  assign PC_ = PCSrcE ? PCBranchM : PCPlus4F;
  assign PCPlus4F = PCF + 32'd4;

  always @(posedge CLK)
  begin
    if (reset)
      PCF <= 0;
    else if (StallF)
      PCF <= PCF;
    else
      PCF <= PC_;
  end
  
  imem im1(.a(PCF), .rd(InstrF));
  
endmodule          
