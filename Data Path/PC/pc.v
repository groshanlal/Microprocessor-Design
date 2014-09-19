module pc(aluout,memout,pc_src,alu,pc,reset,pcwr,clock);
        
        input wire [15:0] alu;
        input wire [15:0] aluout;	
        input wire reset,pcwr,clock;
	     input wire [1:0] pc_src;
        input wire [15:0] memout;
	     output reg [15:0] pc;

        wire [15:0] pc_in;
        assign pc_in    = (pc_src == 2'b00) ? aluout:
                          (pc_src == 2'b01) ? alu:
				              (pc_src == 2'b11) ? memout: 16'h280;

		  
		  
	
 	  
	always @ (negedge clock)	
   begin
	if(reset)
	pc =16'h0001;
	else if (pcwr)
	begin
	pc=pc_in;
	end
	end
endmodule
