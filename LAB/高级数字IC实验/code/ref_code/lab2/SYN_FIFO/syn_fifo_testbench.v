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
syn_fifo #(8,8)
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
parameter p=10;
initial
begin
wr_cs=0;
wr_en=0;
rd_cs=0;
rd_en=0;
clk=0;
rst=1;
#p rst=0;
#p wr_cs=1;
   wr_en=1;
   din=8'b10101010;
#p din=8'b11001100;
#p din=8'b11111111;
#p wr_cs=0;
#p wr_en=0; 
#p rd_cs=1;
#p rd_en=1;
#p ;
#p ;
#p rd_cs=0;
#p rd_en=0;
#1000 $finish;
end
initial
begin
$monitor("the din  is %b ,out is %b at %d",din,dout,$time);
//$monitor("the dout is %b at %d",dout,$time);
end
always #5 clk=~clk;
endmodule