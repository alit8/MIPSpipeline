module HU(input            CLK,
          input            reset,
          input            CacheReady,
          input      [4:0] RsD,
          input      [4:0] RtD,
          input      [4:0] RdD,
          input      [4:0] RsE,
          input      [4:0] RtE,
          input      [4:0] WriteRegE,
          input      [4:0] WriteRegM,
          input      [4:0] WriteRegW,
          input            MemWriteD,
          input            MemWriteE,
          input            MemWriteM,
          input            MemtoRegD,
          input            MemtoRegE,
          input            MemtoRegM,
          input            RegDstD,
          input            RegWriteM,
          input            RegWriteW,
          input            PCSrcE,
          output reg       StallF,
          output reg       StallD,
          output reg       StallE,
          output reg       StallM,
          output reg       FlushD,
          output reg       FlushE,
          output reg       FlushM,
          output reg       FlushW,
          output reg       SkipMem,
          output reg [1:0] ForwardAE,
          output reg [1:0] ForwardBE);
          
    wire branchflush;
    wire branchInD;
    wire lwInE;
    wire lwInM;
    wire swInE;
    wire swInM;
    wire dataDpdED;
    wire sameDstED;
    wire dataDpdMD;
    wire sameDstMD;
    wire dataDpdME;
    wire sameDstME;
    
    reg [1:0] counter;
    
    assign lwInE = MemtoRegE;
    assign lwInM = MemtoRegM;
    assign swInE = MemWriteE;
    assign swInM = MemWriteM;
    assign lwswInD = MemtoRegD | MemWriteD;
    
    assign dataDpdED = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE;
    assign sameDstED = (WriteRegE == (RegDstD ? RdD : RtD)) & MemtoRegM;
    assign dataDpdMD = ((RsD == WriteRegM) | (RtD == WriteRegM)) & MemtoRegM;
    assign sameDstMD = (WriteRegM == (RegDstD ? RdD : RtD)) & MemtoRegM;
    assign dataDpdME = ((RsE == WriteRegM) | (RtE == WriteRegM)) & MemtoRegM;
    assign sameDstME = (WriteRegM == WriteRegE) & MemtoRegM;    
    
    assign branchflush = PCSrcE;
    // assign branchInD = BranchD | BranchND;
    
    reg state;
    reg nextState;
	  
	  parameter normal = 1'b0;
	  parameter swlwInProgress = 1'b1;
	  
	  always @(*)
	  begin
	    StallF = 0;
      StallD = 0;
			FlushD = 0;
			StallE = 0;
			FlushE = 0;
			StallM = 0;
			FlushM = 0;
			FlushW = 0;
			SkipMem = 0;
	    
	    case (state)
	      normal:
	      begin
	         if (reset)
           begin
              nextState = normal;
				   end
			     else if (lwInE)
				   begin
				      nextState = swlwInProgress;
				      
				      if (dataDpdED | sameDstED | lwswInD)
				      begin
				        StallF = 1;
				        StallD = 1;
				        FlushE = 1;
				      end
				   end
				   else if (swInE)
				   begin
				      nextState = swlwInProgress;
				      
				      if (lwswInD)
				      begin
				        StallF = 1;
				        StallD = 1;
				        FlushE = 1;
				      end
				   end 
			     else if (branchflush)
				   begin
				      nextState = normal;
				      
				      FlushD = 1;
				      FlushE = 1;
				   end
			     else
				   begin
				      nextState = normal;
				   end
	      end
	      swlwInProgress:
	      begin
	         if (reset)
           begin
              nextState = normal;
				   end
				   else if (CacheReady)
				   begin
				      nextState = normal;
				   end
				   else if (swInM & lwswInD)
				   begin
				      nextState = swlwInProgress;
				      
				      StallF = 1;
				      StallD = 1;
				      FlushE = 1;
				      StallM = 1;
				      SkipMem = 1;
				   end
				   else if (lwInM & (dataDpdMD | sameDstMD | lwswInD))
				   begin
				      nextState = swlwInProgress;
				      
				      StallF = 1;
				      StallD = 1;
				      FlushE = 1;
				      StallM = 1;
				      SkipMem = 1;
				   end
				   else
				   begin
				      nextState = swlwInProgress;
				      
				      StallM = 1;
				      SkipMem = 1;
				   end
				   
				   if (branchflush)
				   begin      
				      FlushD = 1;
				      FlushE = 1;
				   end  
	      end
	      default: nextState = 1'bx;
	    endcase
    end
    
    always @(posedge CLK)
	  begin
		  if (reset) 
		    state <= 0;
		  else 
		    state <= nextState;
	  end
	  
	  always @(posedge CLK)
	  begin
		  if (reset | (nextState == normal)) 
		    counter <= 0;
		  else 
		  begin
			  if (counter == 2'd3)
				  counter <= 0;
			  else 
			    counter <= counter + 1;
		  end
	  end
    
    always @(*)
    begin
      if ((RsE != 0) & (RsE == WriteRegM) & RegWriteM)
        ForwardAE = 2'b10;
      else if ((RsE != 0) & (RsE == WriteRegW) & RegWriteW)
        ForwardAE = 2'b01;
      else
        ForwardAE = 2'b00;
        
      if ((RtE != 0) & (RtE == WriteRegM) & RegWriteM)
        ForwardBE = 2'b10;
      else if ((RtE != 0) & (RtE == WriteRegW) & RegWriteW)
        ForwardBE = 2'b01;
      else
        ForwardBE = 2'b00;
    end           
                    
endmodule