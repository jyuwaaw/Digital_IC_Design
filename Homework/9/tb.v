module tb;

reg b_in;
reg clk1;
reg reset;
wire frame_clk;
wire req;
wire [3:0]data;
reg clk_2;

homeworkVII_3_PCS_demo PCS_demo
(
.b_in(b_in),
.clk1(clk1),
.reset(reset),
.frame_clk(frame_clk),
.req(req),
.data(data)
);

homeworkVIII_2_Data_Avg Data_Avg
(
.clk_2(clk_2),
.reset(reset),
.req(req),
.data(data),
.avg(avg)
);

initial
clk1 = 0;
always #20 clk1 = ~clk1;

initial
clk_2 = 0;
always #2.5 clk_2 = ~clk_2;

initial
begin
reset = 0;
#10 reset = 1;
#10 reset = 0;
end


always@(posedge clk1)
begin
#4 b_in = $random;
end
/*initial
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
#10 b_in <= 1;
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
end*/

endmodule