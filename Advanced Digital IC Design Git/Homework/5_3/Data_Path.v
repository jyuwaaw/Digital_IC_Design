module Data_Path(
	input 		[7:0]	Data_In,
	input 				Clk,
	input 				Reset,
	input 		[4:0]	ACC_Ctrl,

	output reg 	[7:0]	ACC_Out,
	output  			Count_Reg_judge
	);

//===================================
//define register & wire
reg 	[7:0]	Count_Reg;

wire 	[7:0]	ADD;
wire 	[7:0]	mux1;
wire 	[7:0]	mux2;
wire 	[7:0]	mux3;
wire 	[7:0]	mux4;
wire 	[7:0]	mux5; 		
//===================================

//===================================
//continuous assignment
assign mux1 = ACC_Ctrl[0]? ACC_Out : Count_Reg;
assign mux2 = ACC_Ctrl[1]? Data_In : 8'b11111111;
assign mux3 = ACC_Ctrl[2]? ADD		  : 5'b0;
assign mux4 = ACC_Ctrl[3]? Count_Reg : mux3;
assign mux5 = ACC_Ctrl[4]? ACC_Out    : mux3;
assign ADD 	= mux1 + mux2;
assign Count_Reg_judge = |Count_Reg;
//===================================

always @(posedge Clk) begin
	ACC_Out   <= mux5;
	Count_Reg <= mux4;
end
endmodule