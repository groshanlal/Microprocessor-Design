module control_path(clk, ir,  global_reset,                                                     
ctrl,memRd,memWr,mdr_l,mdr_h,ir_wr,I,                                            //memory
write_en, d8_d16, reg_reset, alu_mem, dr,                                          //regfile
op, frm_mem, flag, imm_offb, toshift, sel_ext, ip1_sel, ip2_sel,                   //alu
pc_src, pc_wr, pc_reset, 																				//pc
n,p,z                                                         
);

input clk, global_reset,n,p,z;
input [15:0] ir;
reg reset;

output reg ctrl,memRd,memWr,mdr_l,mdr_h,ir_wr;
output reg [1:0] I;

output reg write_en, d8_d16, reg_reset, alu_mem;
output reg [2:0] dr;

output reg [2:0] op;
output reg frm_mem, flag, imm_offb;
output reg [1:0]toshift;
output reg sel_ext;
output reg [1:0] ip1_sel;
output reg [1:0] ip2_sel;


output reg [1:0]pc_src; 
output reg pc_wr, pc_reset;

reg [2:0]state;

//opcodes
parameter BR = 4'b0000;
parameter JMP = 4'b1100;
parameter TRAP = 4'b1111;
parameter JSRR = 4'b0100;
parameter LEA = 4'b1110;
parameter LDB= 4'b0010;
parameter STB= 4'b0011;
parameter LDW=4'b0110;
parameter STW=4'b0111;
parameter ADD=4'b0001;
parameter AND=4'b0101;
parameter XOR=4'b1001;
parameter SHIFT=4'b1101;





always@(posedge clk)
begin
if(global_reset)
state=3'd0;

else
begin
case(state)
 3'b000 :  
 //fetch

begin        //2
I=0;        // chosing PC
memRd=1;   // reading from memory
memWr=0;   
ctrl=1;
ir_wr=1'b1;
mdr_l=1'b0;
mdr_h=1'b0;
reset =0;

write_en=1'b0;   // disable regfile
reg_reset =1'b0;

ip1_sel=2'b01;  //-------------//
ip2_sel=2'b01;  // for PC=PC+2 //
op=3'b000;     //-------------//
flag=0;
frm_mem=0;

pc_src=2'b01;  //from alu(imm)
pc_wr=1'b1;
pc_reset=1'b0;

state=3'd1;
end //2*

 3'b001 : 
 //decode
 begin   //3
 
 if(ir[15:12]==BR)
 begin    //4
 
 memRd=0;              //diasble memory
 memWr=0;
 ir_wr=0;
 mdr_h=0;
 mdr_l=0;
 
 write_en=0;          //disable regfile 
 
                       //alu operations
 op = 3'b000;          //add
 frm_mem=0;
 flag=0;
 toshift=2'b00;
 sel_ext=1;
 ip1_sel=2'b01;         //pc
 ip2_sel=2'b10;         //ext


 
 pc_wr=0;          //disable pc write
 pc_reset=0;

 state=3'd2;         //to execute 
 
 end   //4*
 
 else if(ir[15:12]==JMP)
 begin   //5
 memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=0;          //disable regfile 
 
                       //alu operations
 op = 3'b000;          //add
 frm_mem=0;
 flag=0;
 imm_offb=0;
 sel_ext=0;
 ip1_sel=2'b00;         //reg1val
 ip2_sel=2'b10;         //ext


 
 pc_wr=0;              // pc write
 pc_src=2'b01;             //frm alu wire   
 pc_reset=1;

 state=3'd0;         //to fetch 
 
 end    //5*
 
 else if(ir[15:12]==JSRR)
 begin    //6
 
 memRd=0;             //disable memory
 memWr=0;
 
 write_en=1;             //write pc to r7
 d8_d16=1;
 reg_reset=0;
 alu_mem=1;
 dr=3'b111;
 
                       //alu operations
 if(ir[11]==0)
 begin 
 op = 3'b000;          //add
 frm_mem=0;
 flag=0;
 imm_offb=0;
 sel_ext=0;
 ip1_sel=2'b00;         //reg1val
 ip2_sel=2'b10;         //ext
 end
 
 if(ir[11]==1)
 begin
 op = 3'b000;          //add
 frm_mem=0;
 flag=0;
 toshift=1;
 sel_ext=1;
 ip1_sel=2'b01;         //pc
 ip2_sel=2'b10;         //ext
 end


 
 pc_wr=1;              // pc write
 pc_src=2'b10;             //frm alu wire
 pc_reset=0;

 state=3'd0;         //to fetch 
 
 
 end    //6*
 
 else if(ir[15:12]==TRAP)
 begin    //7
 memRd=0;             //disable memory
 memWr=0;
 
 write_en=1;             //write pc to r7
 d8_d16=1; 
 reg_reset=0;
 alu_mem=1;
 dr=3'b111;
 
                       //alu operations
 
 op=3'b111;             //none 2
 frm_mem=0;
 flag=0;
 toshift=2'd3;
 sel_ext=1;
 ip2_sel=2'd2;



 
 pc_wr=1;              // pc write
 pc_src=2'b10;             //frm alu wire
 pc_reset=0;

 
 
 state=3'd4;         //to mem access
 end   //7*
 
 else if(ir[15:12]==LEA)
 begin   //8
 
 memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 
 write_en=0;          //disable regfile 
 
                       //alu operations
 op = 3'b000;          //add
 frm_mem=0;
 flag=1;
 toshift=2'b00;
 sel_ext=1;
 ip1_sel=2'b01;         //pc
 ip2_sel=2'b10;         //ext


 
 pc_wr=0;          //disable pc write
 pc_reset=0;

 state=3'd2;         //to execute 
 
 end //8*
 
  
 else
 begin    //9
 memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=0;          //read regfile 
 
                       //disable alu flags
 frm_mem=0;
 flag=0;
 
 pc_wr=0;          //disable pc write
 pc_reset=0;

 state=3'd2;         //to execute 
 
 
 end //9*

end   //3*


 3'b010 : 
 //execute
 begin  //10
 if(ir[15:12]== LDB)
 begin    //11
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file
 
 ip1_sel=0; //execute
 ip2_sel=2'b10;
imm_offb=0;
sel_ext=0; //no shift
flag=0;
op=3'b000;

 pc_wr=0;          //disable pc write
 pc_reset=0;


state=3'b11;   //to mem access
end    //11*

if(ir[15:12]== STB)
 begin    //11
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file
 
 ip1_sel=0; //execute
 ip2_sel=2'b10;
imm_offb=0;
sel_ext=0; //no shift
flag=0;
op=3'b000;

 pc_wr=0;          //disable pc write
 pc_reset=0;


state=3'b11;   //to mem access
end    //11*


if(ir[15:12]== STW)
begin    //12

memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file

ip1_sel=0;
flag=0;
ip2_sel=2'b10;
op=3'b000;
toshift=2'b10;
sel_ext=1;


 pc_wr=0;          //disable pc write
 pc_reset=0;


state=3'b11;

end    //12

if(ir[15:12]== LDW)
begin    //12

memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file

ip1_sel=0;
flag=0;
ip2_sel=2'b10;
op=3'b000;
toshift=2'b10;
sel_ext=1;


 pc_wr=0;          //disable pc write
 pc_reset=0;


state=3'b11;

end    //12*


if(ir[15:12]== LEA)
begin     //13

memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file

ip1_sel=1;
ip2_sel=2'b10;
op=3'b111; //none2
 ip2_sel=2'd3;//amount
 op=3'b100;//lshift
 op=3'b000;//add
 
 pc_wr=0;          //disable pc write
 pc_reset=0;


state=3'b100;   //to write back
end  //13*

if(ir[15:12]== BR)
begin     //14
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file

flag=0;
frm_mem=0;

 if(ir[11]&n|ir[9]&p|ir[10]&z)
 begin
pc_src=0;    //branch to label
pc_wr=1;
state=3'b000;
end
end   //14*
else
begin    //15
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

write_en=0;  //diasble reg file


 pc_wr=0;          //disable pc write
 pc_reset=0;

flag=0;
frm_mem=0;

if(ir[15:12]==ADD)
begin
ip1_sel=0;
ip2_sel=0;
op=3'b000;
state=3'b100;
end

if(ir[15:12]==AND)
begin
ip1_sel=0;
ip2_sel=0;
op=3'b001;
state=3'b100;
end
if(ir[15:12]==XOR)
begin
ip1_sel=0;
ip2_sel=0;
op=3'b010;
state=3'b100;
end
if(ir[15:12]==SHIFT)
begin    //16
ip1_sel=0;
ip2_sel=0;

if(ir[5:4]==0)
begin
op=3'b011;
state=3'b100;
end

else
if(ir[5:4]==2'b01)
begin
op=3'b100;
state=3'b100;
end
else
if(ir[5:4]==2'b10)
begin
op=3'b101;
state=3'b100;
end
end    //16*
end    //15*
end    //10*

3'b011 : 
 //mem access
begin 
if (ir[15:12]==STB)
begin
I=2'b10;
memRd=1'b0;
memWr=1'b1;
ctrl=1'b0;
mdr_l=1'b0;
mdr_h=1'b0;
ir_wr=1'b0;

write_en=1'b0;    //disable regfile

flag=1'b0;        //disable flags
frm_mem=1'b0;

pc_wr=1'b0;     //disable PC

end

else if (ir[15:12]==LDB)
begin

I=2'b10;
memRd=1'b1;
memWr=1'b0;
ctrl=1'b0;
mdr_l=1'b1;
mdr_h=1'b0;
ir_wr=1'b0;

write_en=1'b0;    //disable regfile

flag=1'b0;        //disable flags
frm_mem=1'b0;

pc_wr=1'b0;     //disable PC

state=3'b100;
end

else if (ir[15:12]==STW)
begin
I=2'b10;
memRd=1'b0;
memWr=1'b1;
ctrl=1'b1;
mdr_l=1'b0;
mdr_h=1'b0;
ir_wr=1'b0;

write_en=1'b0;    //disable regfile

flag=1'b0;        //disable flags
frm_mem=1'b0;

pc_wr=1'b0;     //disable PC

state=3'b000;
end

else if (ir[15:12]==LDW)
begin
I=2'b10;
memRd=1'b1;
memWr=1'b0;
ctrl=1'b1;
mdr_l=1'b1;
mdr_h=1'b1;
ir_wr=1'b0;

write_en=1'b0;    //disable regfile

flag=1'b0;        //disable flags
frm_mem=1'b0;

pc_wr=1'b0;     //disable PC

state=3'b100;
end

if (ir[15:12]==TRAP)
begin

I=2'b10;
memRd=1'b1;
memWr=1'b0;
ctrl=1'b1;
mdr_l=1'b1;
mdr_h=1'b1;
ir_wr=1'b0;

write_en=1'b0;    //disable regfile

flag=1'b0;        //disable flags
frm_mem=1'b0;

pc_wr=1'b0;     //disable PC

state=3'b100;
end
end
 3'b100 : 
 //write back
 begin
 
 if(ir[15:12]==TRAP)
 begin
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=0;          //disable register file 
 
 
 frm_mem=0;              //disable alu
 flag=0;
 

 pc_wr=1;          //pc write
 pc_reset=0;
 pc_src=2'd3;      //frm memory

 state=0;         //back to fetch
 end
 
 else if(ir[15:12]==LEA)
 begin
memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=1;          //disable register file 
 reg_reset=0;
 d8_d16=1; 
 alu_mem=0;
 dr=ir[11:9];
 
 
 ip1_sel=2'd2;      //update flags
 op=3'd7;
 frm_mem=0;
 flag=1;
 
 pc_wr=0;          //pc disable
 pc_reset=0;
 

 state=0;         //back to fetch
 end
 

 else if(ir[15:12]==LDW)
 begin
 memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=1;          //disable register file 
 reg_reset=0;
 d8_d16=1; 
 alu_mem=0;
 dr=ir[11:9];
 
 
 ip1_sel=2'd2;      //update flags
 op=3'd6;
 frm_mem=0;
 flag=1;
 
 pc_wr=0;          //pc disable
 pc_reset=0;
 

 state=0;         //back to fetch
 end
 
 
 else if(ir[15:12]==LDB)
 begin
 memRd=0;              //diasble memory
memWr=0;
ir_wr=0;
mdr_h=0;
mdr_l=0;

 write_en=1;          //disable register file 
 reg_reset=0;
 d8_d16=0; 
 alu_mem=0;
 dr=ir[11:9];
 
 
 ip1_sel=2'd2;      //update flags
 op=3'd7;
 frm_mem=0;
 flag=1;
 
 pc_wr=0;          //pc disable
 pc_reset=0;
 

 state=0;         //back to fetch
 end
 
else if((ir[15:12]==ADD)|(ir[15:12]==XOR)|(ir[15:12]==AND)|(ir[15:12]==SHIFT))
 begin
 memRd=0;              //diasble memory
 memWr=0;
 ir_wr=0;
 mdr_h=0;
 mdr_l=0;

 write_en=1;          //disable register file 
 reg_reset=0;
 alu_mem=1;
 dr=ir[11:9];
 
 ip1_sel=2'd2;      //update flags
 op=3'd7;
 frm_mem=0;
 flag=1;
 
 pc_wr=0;          //pc disable
 pc_reset=0;
 

 state=0;         //back to fetch
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 end
 
 default: state=3'd0;

 
 endcase
end

end


endmodule