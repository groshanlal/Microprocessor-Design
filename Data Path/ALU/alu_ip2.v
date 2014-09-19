//input 2 of alu
module alu_ip2(b,ip2_sel, reg2val, ext, amt4);
output [15:0] b;
input [15:0] reg2val;
input [15:0] ext;
input [3:0] amt4;
input [1:0] ip2_sel;

assign b    = (ip2_sel == 2'b00) ? reg2val:
              (ip2_sel == 2'b10) ? ext:
				  (ip2_sel == 2'b11) ? {12'b0,amt4[3:0]}:    //zero extension
												16'b10;

endmodule