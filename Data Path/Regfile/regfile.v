module regfile (reg1val, reg2val,ir1, ir2,write_en, dr,aluout, mdr16,mdr8, d8_d16,clock, reset,alu_mem,reg6);

 output [15:0] reg1val;        // Reg Output 1
 output [15:0] reg2val;        // Reg Output 2
 output [15:0] reg6;
 
 input [2:0] ir1;        // Source Register1 Select
 input [2:0] ir2;        // Source Register2 Select
 
 input write_en;
 input [2:0] dr;         // Destination Register Select
 
 input [15:0] aluout;
 
 wire [15:0] Wrdata;
 
 input [15:0] mdr16;        // from Memory
 input [7:0] mdr8;
 
 input clock, reset,d8_d16,alu_mem;      

 
 regmux mux(.Wrdata(Wrdata),.aluout(aluout), .mdr16(mdr16),.mdr8(mdr8), .d8_d16(d8_d16),.alu_mem(alu_mem));
 registers_block registers(.reg1val(reg1val), .reg2val(reg2val),.Wrdata(Wrdata), .ir1(ir1), .ir2(ir2),
										.write_en(write_en), .dr(dr),.clock(clock), .reset(reset),.reg6(reg6));

 
 endmodule
