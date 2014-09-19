module regmux (Wrdata,aluout, mdr16,mdr8, d8_d16,alu_mem);

 output [15:0] Wrdata;
 input [15:0] aluout;
  
 input [15:0] mdr16;        // from Memory
 input [7:0] mdr8;
 input d8_d16,alu_mem;      

 wire [15:0] in;
 
 wire [15:0] ex_mdr8;                           //sign extension of corresponding signals
 assign ex_mdr8[7:0]=mdr8[7:0];
 assign ex_mdr8[15:8]={8{mdr8[7]}};

 assign in    = (d8_d16 == 1'b0) ? ex_mdr8: mdr16;
 assign Wrdata[15:0]    = (alu_mem == 1'b0) ? in[15:0]: aluout[15:0];
						 
				 
 endmodule
