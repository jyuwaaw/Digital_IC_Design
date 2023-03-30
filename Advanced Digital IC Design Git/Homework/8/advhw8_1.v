//计算前一个模块输出四个有效值的平均值
module advhw8_1(

    input   req,
    input   frame_clk,
    input   clk_2,
    input   rst,
    input   [3:0]   data,
    output  [3:0]   avg
);

reg [2:0] cnt;
reg [5:0] accu;
reg [3:0] cs,ns;

parameter   IDLE = 4'b0000, LOAD = 4'b1111;    //独热码

always @(posedge clk_2 or posedge rst)
begin
    if(rst)
        cs  <=  IDLE;
    else
        cs  <=  ns;
end

always(*)
begin
    case(cs)
        IDLE : begin
                cnt = 3'b000;
                accu = 6'b00_0000;
                ns = LOAD;
        end
        LOAD : begin if(req)
                begin
                cnt = cnt + 1'b1;
                accu = accu + data;
                ns = LOAD;
                111111 000000 010011 = 1+2+16
