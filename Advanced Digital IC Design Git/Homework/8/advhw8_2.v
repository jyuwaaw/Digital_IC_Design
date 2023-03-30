module homeworkVIII_2_Data_Avg
(
input clk_2,
input reset,
input req,
input [3:0]data,
output reg [3:0]avg
);


reg [2:0]cnt;//握手次数计数器
reg DFF1,DFF2;//req的同步器
//reg [3:0] data_DFF1,data_DFF2;//数据缓冲器
reg [5:0] AU;//算数单元
reg [3:0] current_state,next_state;//状态寄存器


//req经同步器同步
always@(posedge clk_2)
begin
    DFF1 <= req;
    DFF2 <= DFF1;
end


parameter
IDLE = 4'd0,
REQ_ACTIVE = 4'd1,
REQ_RELEASE = 4'd2;


always@(posedge clk_2 or posedge reset)
begin
    if(reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end


always@(*)
begin
    next_state = IDLE;
    case(current_state)
        IDLE :
            begin
            cnt = 3'd0;
            AU = 6'd0;
            next_state = REQ_ACTIVE;
            end
        REQ_ACTIVE :
            begin
                if(DFF2)
                    begin
                        cnt = cnt + 1'b1;//计数握手一次
                        AU = AU + data;//存入数值并计算
                        next_state = REQ_RELEASE;//握手成功，等待释放
                        avg = AU[5:2];//输出当前和/4的结果
                    end
                else
                    next_state = REQ_ACTIVE;//否则继续等待握手
            end
        REQ_RELEASE :
            begin
                if(!DFF2)
                    begin
                        next_state = REQ_ACTIVE;//释放成功，等待下次握手
                        if(cnt == 3'd4)//握手四次后清零
begin
cnt = 3'd0;
AU = 6'd0;
end
else;
end
else
next_state = REQ_RELEASE;//否则继续等待释放
end
default :
next_state = IDLE;
endcase
end


endmodule
