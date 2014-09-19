//datapath
module datapath(clk,                                                          
ctrl,memRd,memWr,mdr_l, mdr_h,ir_wr,I, reset,                                            //memory
write_en, d8_d16, alu_mem, dr,                                           //regfile
op, frm_mem, flag, imm_offb, toshift, sel_ext, ip1_sel, ip2_sel,                  //alu
pc_src, pc_wr, pc_reset,                                                          //pc
alu_out,alu, z,n,p, pc ,reg1val,reg2val,ir,mdr,reg6,                                //latches
Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7                                       //Registers
);

input clk;

input ctrl,memRd,memWr,mdr_l, mdr_h,ir_wr;
input [1:0]I;

input [2:0] dr;
input write_en, d8_d16, reset, alu_mem;


input [2:0] op;
input frm_mem, flag, imm_offb;
input [1:0]toshift;
input sel_ext;
input [1:0] ip1_sel;
input [1:0] ip2_sel;


input [1:0]pc_src;
input pc_wr, pc_reset;


output [15:0] alu_out;
output [15:0]alu;
output z,n,p;

output [15:0] pc;

output [15:0] reg1val;
output [15:0] reg2val;
output [15:0]Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7;

output [15:0] ir;
output [15:0] mdr;

output [15:0] reg6;

wire [15:0] a;
wire [15:0] b;
wire [15:0] ext;
wire [15:0] wr_data;


memory1 memory_unit (.mdr(mdr[15:0]),.ir(ir[15:0]),.ctrl(ctrl),.memRd(memRd),.memWr(memWr),
					.mdr_l(mdr_l), .mdr_h(mdr_h),.ir_wr(ir_wr),.regH(reg1val[15:8]),.regL(reg1val[7:0]),
					.clock(clk),.I(I),.PC(pc[15:0]),.R6(reg6[15:0]),.AluOut(alu_out[15:0]),.reset(reset|pc_reset));


regmux mux(.Wrdata(wr_data),.aluout(alu_out), .mdr16(mdr[15:0]),.mdr8(mdr[7:0]), .d8_d16(d8_d16),.alu_mem(alu_mem));
 
registers_block registers(.Reg0(Reg0),.Reg1(Reg1),.Reg2(Reg2),.Reg3(Reg3),.Reg4(Reg4),
									.Reg5(Reg5),.Reg6(Reg6),.Reg7(Reg7),.reg1val(reg1val), .reg2val(reg2val),
									.Wrdata(wr_data), .ir1(ir[8:6]), .ir2(ir[2:0]),
										.write_en(write_en), .dr(dr),.clock(clk), .reset(reset),.reg6(reg6));

 //regfile regfile_unit(.reg1val(reg1val[15:0]), .reg2val(reg2val[15:0]), .ir1(ir[8:6]), .ir2(ir[2:0]),
 //                     .write_en(write_en), .dr(dr[2:0]), .aluout(alu_out), .mdr16(mdr[15:0]),
//							 .mdr8(mdr[7:0]), .d8_d16(d8_d16),.clock(clk), .reset(reset),
//							 .alu_mem(alu_mem),.reg6(reg6[15:0]));
 
alu alu_unit(.alu_out(alu_out),.alu(alu),
             .z(z),.n(n),.p(p),.a(a[15:0]),.b(b[15:0]),.op(op),
				 .clk(clk),.flag(flag), .mdr16(mdr[15:0]), .frm_mem(frm_mem));
				 
alu_ip1 ip1_unit(.a(a[15:0]),.ip1_sel(ip1_sel), .reg1val(reg1val), 
						.wr_data(wr_data), .pc(pc), .reg6(reg6));

alu_ip2 ip2_unit(.b(b[15:0]),.ip2_sel(ip2_sel), .reg2val(reg2val), .ext(ext), .amt4(ir[3:0]));

extend sign_extender_unit(.ext(ext), .imm_offb(imm_offb), .toshift(toshift), 
									.sel_ext(sel_ext), .imm5(ir[4:0]), .boff6(ir[5:0]), .pc9(ir[8:0]), 
									.pc11(ir[10:0]), .off6(ir[5:0]), .trap8(ir[7:0]));

pc pc_unit(.aluout(alu_out[15:0]),.memout(mdr[15:0]),.pc_src(pc_src[1:0]),
           .alu(alu[15:0]),.pc(pc[15:0]),.reset(reset),.pcwr(pc_wr),.clock(clk));



endmodule