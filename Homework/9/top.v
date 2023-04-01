module homeworkIX_2_TOP #
(
    parameter     AWIDTH = 3,
    parameter     DWIDTH = 4
)
(
input clk_1,
input clk_2,
input reset,
input b_in,
input rrq,
output rempty,
output wfull,
output [3:0]avg
);


wire req_inIF1,req_outIF2;
wire [3:0]data_inIF1,data_outIF2;
wire req_outIF1,req_inIF2;
wire [3:0]data_outIF1,data_inIF2;

top_dual_fifo  #(
    .AWIDTH(AWIDTH),
    .DWIDTH(DWIDTH)
)
fifo
(
    .arst_n(reset),
    .wclk(clk_1),
    .rclk(clk_2),
    .wdv(req_outIF1),
.rrq(rrq),
    .rdv(req_inIF2),
    .wdata(data_outIF1),
    .wfull(wfull),
    .rdata(data_inIF2),
    .rempty(rempty)
);


PCS_demo PCS_demo
(
.clk1(clk_1),
.reset(reset),
.b_in(b_in),
.req(req_inIF1),
.data(data_inIF1)
);



Data_Avg Data_Avg
(
.clk_2(clk_2),
.reset(reset),
.req(req_outIF2),
.data(data_outIF2),
.avg(avg)
);


FIFO_IF1 FIFO_IF1
(
.clk_1(clk_1),
.reset(reset),
.req(req_inIF1),
.data(data_inIF1),
.wfull(wfull),
.IF1_req(req_outIF1),
.IF1_data(data_outIF1)
);


FIFO_IF2 FIFO_IF2
(
.clk_2(clk_2),
.reset(reset),
.IF2_req(req_inIF2),
.IF2_data(data_inIF2),
.rempty(rempty),
.req(req_outIF2),
.data(data_outIF2)
);


endmodule
