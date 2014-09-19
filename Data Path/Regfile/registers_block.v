module registers_block (Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7,reg1val, reg2val,Wrdata, ir1, ir2,write_en, dr,clock, reset,reg6);

 output reg [15:0] reg1val;        // Reg Output 1
 output reg [15:0] reg2val;        // Reg Output 2
 output reg [15:0] reg6;
 reg [15:0] RegFile [7:0]; 			// Defining eight general purpose Registers
 output reg [15:0]Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7;
 
 
 input [15:0] Wrdata;
 input write_en;
 input [2:0] ir1;        // Source Register1 Select
 input [2:0] ir2;        // Source Register2 Select
 input [2:0] dr;         // Destination Register Select
 
 input clock, reset;
 
  always@ (negedge clock)        
begin
if(reset)
begin
 RegFile[0]=16'd0;
 RegFile[1]=16'd0;
 RegFile[2]=16'd0;
 RegFile[3]=16'd3;
 RegFile[4]=16'd4;
 RegFile[5]=16'd24;
 RegFile[6]=16'd20;
 RegFile[7]=16'd21;
 reg1val[15:0]=16'd0;
 reg2val[15:0]=16'd0;
 end
 
 else if(write_en) 
 begin
 RegFile[dr[2:0]]=Wrdata;
 end
 
 reg1val=RegFile[ir1[2:0]];
 reg2val=RegFile[ir2[2:0]];
 reg6 = RegFile[6];
 Reg0=RegFile[0];
 Reg1=RegFile[1]; 
 Reg2=RegFile[2];
 Reg3=RegFile[3];
 Reg4=RegFile[4];
 Reg5=RegFile[5];
 Reg6=RegFile[6];
 Reg7=RegFile[7];

end


 endmodule
