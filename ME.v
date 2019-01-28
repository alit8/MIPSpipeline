module ME(input         CLK,
          input         reset,
          input         MemWriteM,
          input         MemtoRegM,
          input  [31:0] ALUOutM,
          input  [31:0] WriteDataM,
          output [31:0] ReadDataM,
          output        CacheReady);
          
  cache c1(CLK, reset, MemWriteM, ALUOutM, WriteDataM, MemtoRegM, 
           ReadDataM, CacheReady);

endmodule