module lc3b(Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7,clk, reset);

input clk;
input reset;

output [15:0]Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6,Reg7;

wire [1:0]I;
wire ctrl, memRd, memWr;
wire ir_wr, mdr_h, mdr_l;
wire write_en, d8_d16, alu_mem;

wire [2:0] op;
wire frm_mem, flag, imm_offb;
wire [1:0]toshift;
wire sel_ext;
wire [1:0] ip1_sel;
wire [1:0] ip2_sel;

wire [1:0]pc_src;
wire pc_wr, pc_reset;

wire [15:0] alu_out;
wire [15:0]alu;
wire z,n,p;

wire [15:0] pc;

wire [15:0] reg1val;
wire [15:0] reg2val;

wire [15:0] ir;
wire [15:0] mdr;

wire [2:0] dr;//slash

wire [15:0]reg6;
wire reg_reset;
datapath components(.clk(clk),                                                          
.ctrl(ctrl),.memRd(memRd),.memWr(memWr),.mdr_l(mdr_l), .mdr_h(mdr_h),.ir_wr(ir_wr),.I(I[1:0]), .reset(reset),                            //memory
.write_en(write_en), .d8_d16(d8_d16), .alu_mem(alu_mem), .dr(dr),                                           //regfile
.op(op), .frm_mem(frm_mem), .flag(flag), .imm_offb(imm_offb), .toshift(toshift), .sel_ext(sel_ext), .ip1_sel(ip1_sel), .ip2_sel(ip2_sel),                  //alu
.pc_src(pc_src[1:0]), .pc_wr(pc_wr), .pc_reset(pc_reset),
.alu_out(alu_out),.alu(alu), .z(z),.n(n),.p(p), .pc(pc),.reg1val(reg1val),.reg2val(reg2val),.ir(ir),.mdr(mdr),.reg6(reg6),                                                            //pc
.Reg0(Reg0),.Reg1(Reg1),.Reg2(Reg2),.Reg3(Reg3),.Reg4(Reg4),.Reg5(Reg5),.Reg6(Reg6),.Reg7(Reg7));

control_path controller(.clk(clk), .ir(ir),  .global_reset(reset),                                                      
.ctrl(ctrl),.memRd(memRd),.memWr(memWr),.mdr_l(mdr_l),.mdr_h(mdr_h),.ir_wr(ir_wr),.I(I),                                             //memory
.write_en(write_en), .d8_d16(d8_d16), .reg_reset(reg_reset), .alu_mem(alu_mem), .dr(dr),                                          //regfile
.op(op), .frm_mem(frm_mem), .flag(flag), .imm_offb(imm_offb), .toshift(toshift), .sel_ext(sel_ext), .ip1_sel(ip1_sel), .ip2_sel(ip2_sel),                   //alu
.pc_src(pc_src[1:0]), .pc_wr(pc_wr), .pc_reset(pc_reset),.n(n),.p(p),.z(z)                                                           //pc
);


endmodule