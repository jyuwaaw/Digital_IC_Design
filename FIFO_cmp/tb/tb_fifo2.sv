//Code: FIFO testbench
//Auther: Benji Huang
//Org: HRBUST
module tb_fifo2();
    parameter DSIZE = 8;
    parameter ASIZE = 4;

//write clock domain
    reg [DSIZE-1:0] wdata;
    reg             winc;
    reg             wclk;
    reg             wrst_n;
    wire            wfull;

//read clock domain
    wire[DSIZE-1:0] rdata;
    reg             rinc;
    reg             rclk;
    reg             rrst_n;
    wire            rempty;

    reg             stimulated;

always #8 rclk = !rclk;
always #5 wclk = !wclk;

//initial begin
//    $vcdpluson();
//end

initial begin
wrst_n  = 1'b1;
rrst_n  = 1'b1;
wclk    = 1'b0;
rclk    = 1'b0;
winc    = 1'b0;
rinc    = 1'b0;
wdata   = 'b0;

stimulated  = 1'b0;

#20 wrst_n = 1'b0;
    rrst_n = 1'b0;
#20 wrst_n = 1'b1;
    rrst_n = 1'b1;

#20 stimulated = 1'b1;

#3000   $stop;

    $vcdpluson();

end

always @(*)begin
    if(stimulated)begin
        if(wfull == 1'b1)
                winc = 1'b0;
        else
                winc = 1'b1;
    end
end

always @(*)begin
    if(stimulated)begin
            if(rempty == 1'b1)
                    rinc = 1'b0;
            else
                    rinc = 1'b1;
    end
end

always @(posedge wclk)begin
    if(stimulated)begin
            if(wfull == 1'b0)
                    //wdata <= $random%511;
                    wdata <= wdata + 1;
            else
                    wdata <= wdata;
    end
end

fifo2 #(.DSIZE(8),.ASIZE(4)) FIFO
(
    .rdata  (rdata),
    .wdata  (wdata),
    .wfull  (wfull),
    .rempty (rempty),
    .winc   (winc),
    .wclk   (wclk),
    .wrst_n (wrst_n),
    .rinc   (rinc),
    .rclk   (rclk),
    .rrst_n (rrst_n)

);

endmodule
