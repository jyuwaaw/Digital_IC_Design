module tb_advhw7_3_PCS_demo();

reg b_in;
reg clk1;
reg rst;
wire frame_clk;
wire req;
wire [3:0]data;

advhw7_3_PCS_demo PCS_demo
(
.b_in(b_in),
.clk1(clk1),
.rst(rst),
.frame_clk(frame_clk),
.req(req),
.data(data)
);

initial
clk1 = 0;
always #5 clk1 = ~clk1;
initial
begin
rst = 0;
#10 rst = 1;
#10 rst = 0;
end

always@(posedge clk1)
begin
#15 b_in = $random;
end

/*
initial
begin
b_in <= 0;
#50 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 0;
#50 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 0;
#10 b_in <= 1;
#10 b_in <= 1;
*/


endmodule
