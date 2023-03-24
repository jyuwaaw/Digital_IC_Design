//HRBUST Benji tutorial Mar25/2023
module fifo2 #(parameter DSIZE = 8, parameter ASIZE = 4)
(	output [DSIZE-1:0] rdata,
	output wfull,
	output rempty,
	input [DSIZE-1:0] wdata,
	input winc, wclk, wrst_n,
	input rinc, rclk, rrst_n,
	wire [ASIZE-1:0] wptr, rptr,
	wire [ASIZE-1:0] waddr, raddr);
	
 async_cmp #(ASIZE) 	async_cmp
						(.aempty_n(aempty_n), .afull_n(afull_n),
						.wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
						
 fifomem #(DSIZE, ASIZE) fifomem
						(.rdata(rdata), .wdata(wdata),
						.waddr(wptr), .raddr(rptr),
						.wclken(winc), .wclk(wclk));
						
 rptr_empty #(ASIZE) 	rptr_empty
						(.rempty(rempty), .rptr(rptr),
						.aempty_n(aempty_n), .rinc(rinc),
						.rclk(rclk), .rrst_n(rrst_n));
						
 wptr_full #(ASIZE) 	wptr_full
						(.wfull(wfull), .wptr(wptr),
						.afull_n(afull_n), .winc(winc),
						.wclk(wclk), .wrst_n(wrst_n));
endmodule
