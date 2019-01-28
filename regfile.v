module regfile(input         clk, 
               input         we3, 
               input  [4:0]  ra1, 
               input  [4:0]  ra2, 
               input  [4:0]  wa3, 
               input  [31:0] wd3, 
               output [31:0] rd1, 
               output [31:0] rd2);

  reg [31:0] rf [31:0];

  always @(posedge clk) 
    if (we3) rf[wa3] <= wd3;

  assign rd1 = (ra1 == 0) ? 0 : rf[ra1];
  assign rd2 = (ra2 == 0) ? 0 : rf[ra2];
  
endmodule