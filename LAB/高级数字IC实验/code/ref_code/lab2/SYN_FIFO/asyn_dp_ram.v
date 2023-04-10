module asyn_dp_ram(din,wptr,wr_en,wr_cs,dout,rptr,rd_en,rd_cs);
parameter DATA_WIDTH=8;
parameter ADDR_WIDTH=8;
parameter DEPT_WIDTH=(1<<ADDR_WIDTH);
input [DATA_WIDTH-1:0] din;
input [ADDR_WIDTH-1:0] wptr;
input [ADDR_WIDTH-1:0] rptr;
input wr_en;
input wr_cs;
input rd_en;
input rd_cs;
output [DATA_WIDTH-1:0] dout;

reg [DATA_WIDTH-1:0] dout;
reg [DATA_WIDTH-1:0] mem [DEPT_WIDTH-1:0];
//write data port
always@(din or wptr or wr_en or wr_cs)
begin
if(wr_en&&wr_cs)
mem[wptr]=din;
end
//read data port
always@(rptr or rd_en or rd_cs)
begin
if(rd_en&&rd_cs)
dout=mem[rptr];
end

endmodule 