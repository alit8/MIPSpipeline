module WB(input         MemtoRegW,
          input  [31:0] ReadDataW,
          input  [31:0] ALUOutW,
          output [31:0] ResultW);
          
  assign ResultW = MemtoRegW ? ReadDataW : ALUOutW;

endmodule
