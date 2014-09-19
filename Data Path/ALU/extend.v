//sign extension, zero extension, shift 
module extend(ext, imm_offb, toshift, sel_ext, imm5, boff6, pc9, pc11, off6, trap8);
output [15:0] ext;
input [4:0] imm5;
input [5:0] boff6;
input [8:0] pc9;
input [10:0] pc11;
input [5:0] off6;
input [7:0] trap8;

input imm_offb;
input [1:0] toshift;
input sel_ext;

wire [15:0] ext_imm5;                           //sign extension of corresponding signals
assign ext_imm5[4:0]=imm5[4:0];
assign ext_imm5[15:5]={11{imm5[4]}};

wire [15:0] ext_boff6;
assign ext_boff6[5:0]=boff6[5:0];
assign ext_boff6[15:6]={10{boff6[5]}};

wire [15:0] ext_pc9;
assign ext_pc9[8:0]=pc9[8:0];
assign ext_pc9[15:9]={7{pc9[8]}};

wire [15:0] ext_pc11;
assign ext_pc11[10:0]=pc11[10:0];
assign ext_pc11[15:11]={5{pc11[10]}};

wire [15:0] ext_off6;
assign ext_off6[5:0]=off6[5:0];
assign ext_off6[15:6]={10{off6[5]}};

wire [15:0] ext_trap8;                                //zero extension
assign ext_trap8[7:0]=trap8[7:0];
assign ext_trap8[15:8]=8'b0;

wire [15:0] m1;
wire [15:0] m2;

assign m1   = (imm_offb == 1'b1) ? ext_imm5[15:0]:        //mux for type 1 (sign extension alone)
                                   ext_boff6[15:0];

assign m2   = (toshift == 2'b00) ? ext_pc9[15:0]:        //mux of type 2 (sign/zero extension followed with shift)
              (toshift == 2'b01) ? ext_pc11[15:0]:
	      (toshift == 2'b10) ? ext_off6[15:0]:
				   ext_trap8[15:0];
              
wire [15:0] m3;

assign m3 = (m2<<1)|16'b1;                                  //shift

assign ext = (sel_ext == 1'b0) ? m1: 
                                 m3;



endmodule
