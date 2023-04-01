//先写入所有RAM所有数据，然后写计数器比读计数器慢一拍，形成加一个数同时减一个数。
module average_calculate
	#(
		parameter N = 10,
		parameter DATA_WIDTH = 24,
		parameter DATA_DEPTH = N,
		parameter RAM_DEPTH = N
	)
	(
	input	clk,
	input	rst_n,
	input	[DATA_WIDTH-1:0]	data_in,
	output	reg	[DATA_WIDTH-1:0]	data_out
);

reg	[31:0] cnt;
wire wr_req;
reg rd_req;

reg [DATA_WIDTH-1:0] wr_cnt;
reg [DATA_WIDTH-1:0] wr_cnt_r;
reg [DATA_WIDTH-1:0] rd_cnt;

reg [33:0]	data_all;
reg [23:0]	data_average;

reg [DATA_WIDTH-1:0] register[RAM_DEPTH-1:0];
//写请求一直使能
assign wr_req = 1'b1;
//计数器控制
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt <= 32'd0;
	else if(cnt == N)
		cnt <= cnt;
	else
		cnt <= cnt + 1'b1;
end
//当写入所有数据时开始读
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rd_req <= 1'b0;
	else if(cnt == N-1)
		rd_req <= 1'b1;
	else
		rd_req <= rd_req;
end
//所有数据的和
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		data_all <= 'd0;
	else if(cnt == N)
		data_all <= data_all + register[wr_cnt] - register[rd_cnt];
	else
		data_all <= data_all + register[wr_cnt];
end
//所有数据的和求平均
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		data_average <= 'd0;
	else if(cnt == N)
		data_average <= data_all/(N-1);
	else
		data_average <= 'd0;
end
//输出
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		data_out <= 'd0;
	else
		data_out <= data_average;
end
//写计数器累加
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		wr_cnt_r <= 'd0;
	else if(wr_cnt_r == RAM_DEPTH-1'b1)
		wr_cnt_r <= 'd0;
	else
		wr_cnt_r <= wr_cnt_r + 1'b1;
end
//写计数器寄存一拍
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		wr_cnt <= 'd0;
	else
		wr_cnt <= wr_cnt_r;
end
//读计数器累加
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rd_cnt <= 'd0;
	else if(rd_cnt == RAM_DEPTH-1'b1)
		rd_cnt <= 'd0;
	else
		rd_cnt <= rd_cnt + 1'b1;
end
//赋初始值
integer i;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<RAM_DEPTH; i=i+1'b1)
			register[i] <= 'd0;
	end
	else if(wr_req == 1'b1)
		register[wr_cnt_r] <= data_in;
end
endmodule
