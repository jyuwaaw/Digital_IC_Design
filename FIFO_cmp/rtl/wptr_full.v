module wptr_full (wfull, wptr, afull_n, winc, wclk, wrst_n);
    parameter ADDRSIZE = 4;
    output wfull;
    output [ADDRSIZE-1:0] wptr;
    input afull_n;
    input winc, wclk, wrst_n;
    reg [ADDRSIZE-1:0] wptr, wbin;
    reg wfull, wfull2;
    wire [ADDRSIZE-1:0] wgnext, wbnext;
 //---------------------------------------------------------------
 // GRAYSTYLE2 pointer
 //---------------------------------------------------------------
always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) begin
        wbin <= 0;
        wptr <= 0;
    end
    else begin
        wbin <= wbnext;
        wptr <= wgnext;
    end
 //---------------------------------------------------------------
 // increment the binary count if not full
 //---------------------------------------------------------------
assign wbnext = !wfull ? wbin + winc : wbin;
assign wgnext = (wbnext>>1) ^ wbnext; // binary-to-gray conversion
always @(posedge wclk or negedge wrst_n or negedge afull_n)
    if (!wrst_n ) 
        {wfull,wfull2} <= 2'b00;
    else if (!afull_n) 
        {wfull,wfull2} <= 2'b11;
    else 
        {wfull,wfull2} <= {wfull2,~afull_n};
endmodule
