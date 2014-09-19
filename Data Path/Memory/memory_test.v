module memory_test(clock);
wire [15:0] mdr;
wire [15:0] ir;

input clock;
reg [15:0]R6;
reg [15:0]PC;
reg [15:0]AluOut;

reg ctrl,memRd,memWr,ir_wr, mdr_l, mdr_h;
reg [1:0]I;
reg [7:0]regH;
reg [7:0]regL;

memory1 test(.mdr(mdr[15:0]),.ir(ir[15:0]),.ctrl(ctrl),
					.memRd(memRd),.memWr(memWr),.mdr_l(mdr_l), .mdr_h(mdr_h),
					.ir_wr(ir_wr),.regH(regH[7:0]),.regL(regL[7:0]),
					.clock(clock),.I(I[1:0]),.PC(PC[15:0]),.R6(R6[15:0]),.AluOut(AluOut[15:0]));

					
					
initial     //assign input latches
begin

PC     = 16'd2;
R6     = 16'd1;
AluOut = 16'd3;

@(posedge clock);     //write to memL[1] => 1

ctrl=0;
memRd=0;
memWr=1;
I=2'b00;
regH=8'd2;
regL=8'd1;

@(posedge clock);     //write to memH[1] => 5

ctrl=0;
memRd=0;
memWr=1;
I=2'b10;
regH=8'd5;
regL=8'd6;

@(posedge clock);     //write to memH[0] and memL[0] => 4,3

ctrl=1;
memRd=0;
memWr=1;
I=2'b01;
regH=8'd4;
regL=8'd3;



@(posedge clock)    //read to mdr_l from memL[1]

ctrl=1;
memRd=1;
memWr=0;
ir_wr=0;
mdr_l=1;
mdr_h=0;
I=2'b10;

@(posedge clock)    //read to mdr_h from memH[1]

ctrl=1;
memRd=1;
memWr=0;
ir_wr=0;
mdr_l=0;
mdr_h=1;
I=2'b00;


@(posedge clock)    //read to ir from memH[0] and memL[0]

ctrl=1;
memRd=1;
memWr=0;
ir_wr=1;
mdr_l=0;
mdr_h=0;
I=2'b01;


end

endmodule