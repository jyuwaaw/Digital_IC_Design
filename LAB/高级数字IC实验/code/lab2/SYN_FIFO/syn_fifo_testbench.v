`timescale 1ns/10ps 
module syn_fifo_testbench;
	reg clk;
	reg rst;
	reg wr_cs;
	reg rd_cs;
	reg  [7:0] din;
	reg rd_en;
	reg wr_en;
	wire [7:0] dout;
	wire empty;
	wire full;
	syn_fifo #(8,4)
	         u1(.clk(clk),
	            .rst(rst),
	            .wr_cs(wr_cs),
	            .wr_en(wr_en),
	            .din(din),
	            .rd_cs(rd_cs),
	            .rd_en(rd_en),
	            .dout(dout),
	            .empty(empty),
	            .full(full)
	);
	
	initial
	begin
	//Code1: Fill your code here 
	end
	initial
	begin
	$monitor("the din  is %b ,out is %b at %d",din,dout,$time);
	//$monitor("the dout is %b at %d",dout,$time);
	end
	always #5 clk=~clk;
endmodule