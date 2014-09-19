//input 1 one of alu
module alu_ip1(a,ip1_sel, reg1val, wr_data, pc, reg6);
output [15:0] a;
input [15:0] reg1val;
input [15:0] wr_data;
input [15:0] pc;
input [15:0] reg6;
input [1:0] ip1_sel;

assign a    = (ip1_sel == 2'b00) ? reg1val:
              (ip1_sel == 2'b01) ? pc:
				  (ip1_sel == 2'b10) ? wr_data: reg6;

endmodule