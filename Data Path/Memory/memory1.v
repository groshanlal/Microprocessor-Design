module memory1 (mdr,ir,ctrl,memRd,memWr,mdr_l, mdr_h,ir_wr,regH,regL,clock,I,PC,R6,AluOut, reset);
output reg [15:0] mdr;
output reg [15:0] ir;
input reset;
wire [15:0] addr;

input ctrl,memRd,memWr,clock,ir_wr, mdr_l, mdr_h;
input [1:0]I;
input [15:0]AluOut;
input [15:0]R6;
input [15:0]PC;
input [7:0]regH;
input [7:0]regL;

reg [7:0]memL[255:0];
reg [7:0]memH[255:0];


integer i;
parameter BR = 4'b0000;
parameter JMP = 4'b1110;
parameter TRAP = 4'b1100;
parameter JSRR = 4'b0100;
parameter LEA = 4'b1111;
parameter LDB= 4'b0010;
parameter STB= 4'b0011;
parameter LDW=4'b0110;
parameter STW=4'b0111;
parameter ADD=4'b0001;
parameter AND=4'b0101;
parameter XOR=4'b1001;
parameter SHIFT=4'b1101;




assign addr    = (I == 2'b00) ? PC:
                 (I == 2'b01) ? R6:
				     (I == 2'b10) ? AluOut: 16'd0;


		


always@ (negedge clock)
begin //1
		if(reset)
		begin
		
		memL[0]=8'b10000000;
		memH[0]=8'b01100001;   //LDW in R[0] from mem[7](110+001)
		
		memL[1]=8'b11000000;
		memH[1]=8'b01100011;   //LDW in R[1] from mem[8](111+001)
		
		memL[2]=8'b00000001;
		memH[2]=8'b00010100;   //R[0]+R[1]->R[2]
		
		memL[3]=8'b10000110;
		memH[3]=8'b01110100;   //Store R[5] to mem[12]
		
		memL[4]=8'b11111100;    //BR to R3(00)
		memH[4]=8'b00001111;
		
		for(i=5;i<256;i=i+1)
		begin
		memL[i]=i/8;
		memH[i]=i/8;
		end
		end
		
		if(memWr)                    //For writing into memory
		begin //3
			if (ctrl==1)    
			begin
				memH[addr[8:1]]=regH;
				memL[addr[8:1]]=regL;
			end
			
			if (ctrl==0)  
			begin
				if(addr[0]==1)      //to H
				begin
					memH[addr[8:1]]=regL;
				end 
				
				if (addr[0]==0)     //to L     
				begin
					memL[addr[8:1]]=regL;
				end 
		   end
				
			 
		end
			
		if (memRd)                   //For reading from memory
		begin
		
		if(ir_wr==1)
		begin
					ir[15:8]=memH[addr[8:1]];
					ir[ 7:0]=memL[addr[8:1]];
	   end
		
		if((mdr_l==1)&(mdr_h==1))
						begin
					mdr[15:8]=memH[addr[8:1]];
					mdr[ 7:0]=memL[addr[8:1]];
	  				 end
		
		if((mdr_l==1)&(mdr_h==0))
		begin
		if(addr[0]==0)           //from L
			begin
			mdr[ 7:0]=memL[addr[8:1]];
			mdr[15:8]=8'd0;
			end
			
		if(addr[0]==1)           //from H
			begin
			mdr[ 7:0]=memH[addr[8:1]];
			mdr[15:8]=8'd0;
			end
		
		end
		
		if((mdr_l==0)&(mdr_h==1))
		begin
		if(addr[0]==0)           //from L
			begin
			mdr[15:8]=memL[addr[8:1]];
			mdr[ 7:0]=8'd0;
			end
			
		if(addr[0]==1)           //from H
			begin
			mdr[15:8]=memH[addr[8:1]];
			mdr[ 7:0]=8'd0;
			end
		
		end
		
		
		
		
			
				
		end	
		
		
		
		end
		

endmodule