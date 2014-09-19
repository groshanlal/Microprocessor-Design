//alu design
module alu(alu_out,alu,z,n,p,a,b,op,clk,flag, mdr16, frm_mem);
input frm_mem;
input [15:0] mdr16;
input flag;
input clk;
input signed [15:0]a;
input signed [15:0]b;
input [2:0] op;
output reg signed[15:0]alu_out;
output reg z,n,p;
output signed [15:0]alu;
assign alu  = (op == 3'b000) ? a+b:                      //16-bit addition
              (op == 3'b001) ? a&b:                      //16-bit logical and
				  (op == 3'b010) ? a^b:                    //16 bit xor
              (op == 3'b011) ? a<<b:                     //left shift
              (op == 3'b100) ? a>>b:                   //right shift 
              (op == 3'b101) ? a>>>b:                     //right shift arithmetic
	           (op == 3'b110) ? a:                        //none 1
			                      b;                        //none 2
       


//not(p,out[15]);
//not(n,p);
//nor(z,out[15],out[14],out[13],out[12],out[11],out[10],out[9],out[8],out[7],out[6],out[5],out[4],out[3],out[2],out[1],out[0]);

always@(negedge clk)
begin

alu_out=alu;       //latch the output

if(flag)
begin
if(alu_out==16'b0) z=1; else z=0;

p=~alu_out[15];
n=alu_out[15];

end

if(frm_mem)            //psr update from memory as in return from some call statements
begin
p=mdr16[0];
z=mdr16[1];
n=mdr16[2];
end

end


endmodule

