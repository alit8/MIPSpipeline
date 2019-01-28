
`timescale 1ns/1ns

module TB2;

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
      $readmemh("TB2.hex", ACA_MIPS.dpath1.if1.im1.RAM);

   parameter end_pc = 32'h40;

   integer i;
   always @(ACA_MIPS.dpath1.me1.c1.dm1.RAM[499])
   begin
      if(ACA_MIPS.dpath1.me1.c1.dm1.RAM[499] == 32'h1f4) begin
        
         for(i=0; i<1000; i=i+1) begin
            $write("%x ", ACA_MIPS.dpath1.me1.c1.dm1.RAM[i]);
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         
         
         $stop;
      end
   end
   
    /* always @(posedge clk)
   begin
     if (ACA_MIPS.dpath1.if1.PCF == 32'h3c)
       begin
         $display("%d - %b - %h", ACA_MIPS.dpath1.de1.rf1.rf[8], ACA_MIPS.dpath1.ex1.PCSrcE, ACA_MIPS.dpath1.if1.PC_);
         i = i + 1;
         if(i==1000)
           begin
             for(i=0; i<1000; i=i+1) begin
            $write("%x ", ACA_MIPS.dpath1.me1.c1.dm1.RAM[i]);
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
       end
     end
     
     if (ACA_MIPS.dpath1.if1.PCF == 32'h28)
       begin
         $display("%h - %b\n", ACA_MIPS.dpath1.if1.PC_, ACA_MIPS.dpath1.if1.PCSrcE);
       end
   end*/
   
   Top_Ph3 ACA_MIPS(
      .CLK(clk),
      .reset(reset)
   );


endmodule



