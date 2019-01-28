module imem(input  [31:0] a,
            output [31:0] rd);

  reg [31:0] RAM [127:0];
  
  assign rd = RAM[a[31:2]];
  
endmodule
