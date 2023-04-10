module syn_fifo(clk,
                rst,
                wr_cs,
                wr_en,
                din,
                rd_cs,
                rd_en,
                dout,
                empty,
                full
);
parameter DATA_WIDTH=8;
parameter ADDR_WIDTH=8;
parameter DEPT_WIDTH=(1<<ADDR_WIDTH);
input clk;
input rst;
input wr_cs;
input rd_cs;
input [DATA_WIDTH-1:0] din;
input rd_en;
input wr_en;
output [DATA_WIDTH-1:0] dout;
output empty;
output full;

reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] status;

assign empty=(status==0);
assign full=(status==DEPT_WIDTH);

// write data into fifo
always@(posedge clk or posedge rst)
begin
 if(rst)begin
   wptr=0;
 end
 else if(wr_en&&wr_cs&&!full)begin
   wptr=wptr+1;
 end
end
//read data from fifo
always@(posedge clk or posedge rst)
begin
 if(rst)begin
  rptr=0;
 end
 else if(rd_en&&rd_cs&&!empty)begin
  rptr=rptr+1;
 end
end
//count fifo status
always@(posedge clk or posedge rst)
begin
 if(rst)begin
    status=0;
 end
 else if((wr_en&&wr_cs)&&!(rd_en&&rd_cs)&&!full)begin
    status=status+1;
 end
 else if(!(wr_en&&wr_cs)&&(rd_en&&rd_cs)&&!empty)begin
          status=status-1;
 end
 else begin
   status=status;
 end
end      
asyn_dp_ram#(DATA_WIDTH,ADDR_WIDTH,DEPT_WIDTH)
 u(.din(din),
   .wptr(wptr),
   .wr_en(wr_en),
   .wr_cs(wr_cs),
   .dout(dout),
   .rptr(rptr),
   .rd_en(rd_en),
   .rd_cs(rd_cs)
 );
endmodule
