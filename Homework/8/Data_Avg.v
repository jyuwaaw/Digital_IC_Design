//计算前一个模块输出四个有效值的平均值
module Data_Avg(
    #(parameter N = 5)
    input   req,
    input   frame_clk,
    input   clk_2,
    input   rst,
    input   [3:0]   data,
    output  [3:0]   avg
);


reg [3:0] cnt;
wire wr_req;    //Write Request
wire rd_req;    //Read Request
wire [3:0] data_cal;
reg clk;
reg rst_n;

reg [3:0] wr_cnt;   //Count write times
reg [3:0] wr_cnt_r;
reg [3:0] rd_cnt;   //Count read times

reg [4:0] data_sum; //Result of all data adding up
reg [4:0] data_average; //Average

reg [3:0] DFF[3:0]; //Register reuse

assign clk = clk_2;
assign rst_n = !rst;  

assign wr_req = 1'b1;   //Always enable writing request

//////  ******  MUX of [3:0] data and '0'   ******  //////
always @(posedge clk) begin
    if(!req)
        data_cal <= 4'b0000;
    else
        data_cal <= data;
end

//////  ******  Algorithm Unit  ******    //////
//Counter control
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= 4'b0000;
    else if(cnt == N)
        cnt <= 4'b0000;
    else
        cnt <= cnt + 1'b1;
end
//Begin reading when all data are in
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rd_req <= 1'b0;
    else if(cnt == N-1)
        rd_req <= 1'b1;
    else
        rd_req <= rd_req;
end
//Addition of numbers
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_sum <= 'd0;
    else if(cnt == N)
        data_sum <= data_sum + DFF[wr_cnt] - DFF[rd_cnt];
    else
        data_sum <= data_sum + DFF[wr_cnt];
end
//Division of all data
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_average <= 'd0;
    else if(cnt == N)
        data_average <= data_sum/(N-1);
    else
        data_average <= 'd0;
end
//Output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        avg <= 'd0;
    else
        avg <= data_average;
end
//Control write counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wr_cnt_r <= 'd0;
    else if(wr_cnt_r == 4)
        wr_cnt_r <= 'd0;
    else
        wr_cnt_r <= wr_cnt_r + 1'b1;
end
//Write counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wr_cnt <= 'd0;
    else
        wr_cnt <= wr_cnt_r;
end
//Read counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rd_cnt <= 'd0;
    else if(rd_cnt == 4)
        rd_cnt <= 'd0;
    else
        rd_cnt <= rd_cnt +1'b1;
end
//Initialize
integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<4;i=i+1'b1)
            DFF[i] <= 'd0;
    end
    else if(wr_req == 1'b1)
        DFF[wr_cnt_r] <= data_cal;
end
//////  ****** End of Algorithm Unit  ******    //////

endmodule
