
`timescale 1ns/1ns

module multi_cycle_mips__tb;

   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 0;
   end
   
   /*integer f;
   initial begin
      f = $fopen("output.txt","w");
   end*/

   initial
      $readmemh("isort32.hex", ACA_MIPS.dpath1.if1.im1.RAM);

   parameter end_pc = 32'h80;

   integer i;
   always @(ACA_MIPS.dpath1.if1.PCF)
   begin
      if(ACA_MIPS.dpath1.if1.PCF == end_pc) begin
        
         for(i=0; i<96; i=i+1) begin
            $write("%x ", ACA_MIPS.dpath1.me1.c1.dm1.RAM[32+i]);
            if(((i+1) % 16) == 0)
               $write("\n");
         end
      
         $stop;
      end
   end
   
   
  /*always @(posedge clk)
   begin
     $display("%h - %b - %b - %b", ACA_MIPS.dpath1.if1.PCF, ACA_MIPS.hu1.CacheReady, ACA_MIPS.hu1.swInM, ACA_MIPS.hu1.lwInM);
  end     
  
  wire we = ACA_MIPS.dpath1.me1.c1.dm1.we;
   wire dwe = ACA_MIPS.dpath1.me1.c1.dm1.dwe;*/
  
   Top_Ph3 ACA_MIPS(
      .CLK(clk),
      .reset(reset)
   );


endmodule

