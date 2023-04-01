module homeworkVII_3_PCS_demo
(
input b_in,
input clk1,
input reset,
output frame_clk,
output req,
output reg [3:0]data
);


reg work;//req控制信号
reg [3:0]data_effect;//有效数据寄存器
reg en;//有效数据信号
reg cnt,clk_temp;//计数器和时钟寄存
reg [4:0]current_state,next_state;//状态机
reg [6:0]data_temp;//七位移位寄存器


//状态机参数
parameter
S_IDLE = 5'd0,
S0 = 5'd1,
S1 = 5'd2,
S2 = 5'd3,
S3 = 5'd4,
S4 = 5'd5,
S5 = 5'd6,
S6 = 5'd7,
S7 = 5'd8,
S8 = 5'd9,
S9 = 5'd10,
S10 = 5'd11,
S11 = 5'd12,
S12 = 5'd13,
S13 = 5'd14,
S14 = 5'd15,
S15 = 5'd16,
S16 = 5'd17;


//时钟分频
//*******************************************************//
always@(posedge clk1 or posedge reset)
begin
if(reset)
cnt <= 1'd0;
else if(cnt == 1)
cnt <= 1'd0;
else
cnt <= cnt + 1'b1;
end


always@(posedge clk1 or posedge reset)
begin
if(reset)
clk_temp <= 1'b0;
else if((cnt == 1))
clk_temp <= ~clk_temp;
else
clk_temp <= clk_temp;
end

assign frame_clk = clk_temp;
//*******************************************************//


//状态机
//*******************************************************//
always@(posedge clk1 or posedge reset)
begin
if(reset)
current_state <= S_IDLE;

else
current_state <= next_state;
end


always@(*)
begin
next_state = S_IDLE;
case(current_state)
S_IDLE :
begin
if(reset)
next_state = S_IDLE;
else
next_state = S0;
end

S0 :
begin
if(b_in)
next_state = S1;
else
next_state = S0;
end


S1 :
begin
if(b_in)
next_state = S2;
else
next_state = S0;
end


S2 :
begin
if(b_in)
next_state = S3;
else
next_state = S0;
end


S3 :
begin
if(b_in)
next_state = S4;
else
next_state = S0;
end//到此对齐符号1111检测完毕，开始串并转换工作。


S4 :
next_state = S5;

S5 :
next_state = S6;

S6 :
next_state = S7;

S7 :
next_state = S8;

S8 :
next_state = S9; // S4时不可能是1，所以在S8不做对齐符号的判断。

S9 :
begin
if(data_temp[3:0] == 4'b1111)
next_state = S14;
else
next_state = S10;
end//data_temp中低五位进数成功，要从第二位开始判断后面的序列是否是对齐符号。

S10 :
begin
if(data_temp[3:0] == 4'b1111)
next_state = S15;
else
next_state = S11;
end

S11 :
begin
if(data_temp[3:0] == 4'b1111)
next_state = S16;
else
next_state = S12;
end

S12 :
begin
if(data_temp[3:0] == 4'b1111)
next_state = S13;
else
next_state = S9;//从S12到S9总共读入四个数，故回到S9。
end
S13 :
next_state = S14;
S14 :
next_state = S15;
S15 :
next_state = S16;

S16 :
begin
if({data_temp[2:0],b_in} == 4'b1111)
next_state = S4;
else if({data_temp[1:0],b_in} == 3'b111)
next_state = S3;
else if({data_temp[0],b_in} == 2'b11)
next_state = S2;
else if(b_in == 1'b1)
next_state = S1;
else
next_state = S0;
end

default : 
next_state = S_IDLE;
endcase


end


always@(posedge clk1 or posedge reset)
begin
if(reset)
begin
data_temp <= 7'b0000000;
en <= 1'b0;
end

else
begin
case(next_state)
S4 :
begin
data_temp <= {data_temp[5:0],b_in};
en <= 1'b0;
end

S5 : 
data_temp <= {data_temp[5:0],b_in};

S6 :
data_temp <= {data_temp[5:0],b_in};

S7 :
data_temp <= {data_temp[5:0],b_in};

S8 :
data_temp <= {data_temp[5:0],b_in};

S9 :
data_temp <= {data_temp[5:0],b_in}; 

S10 :
data_temp <= {data_temp[5:0],b_in};

S11 :
data_temp <= {data_temp[5:0],b_in};

S12 :
begin
data_temp <= {data_temp[5:0],b_in};
data_effect <= data_temp[6:3];
en <= 1'b1;
end
S13 :
begin
data_temp <= {data_temp[5:0],b_in};
en <= en;
end
S14 :
begin
data_temp <= {data_temp[5:0],b_in};
en <= en;
end
S15 :
begin
data_temp <= {data_temp[5:0],b_in};
en <= en;
end
S16 :
begin
data_temp <= {data_temp[5:0],b_in};
en <= 1'b0;
end
default : 
begin
data_temp <= {data_temp[5:0],b_in};
en <= 1'b0;
end
endcase
end
end


always@(posedge clk_temp or posedge reset)
begin
if(reset)
begin
data <= 4'b0000;
work <= 1'b0;
end
else if(en)
begin
data <= data_effect;
work <= 1'b1;
end
else
begin
data <= data;
work <= 1'b0;
end
end


assign req = clk_temp & work;

endmodule


