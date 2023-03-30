module ACC(
	input 			Clk,
	input 			Reset,
	input 			Load,
	input 	[7:0] 	Data_In,

	output 			Done,
	output 	[7:0]	ACC_Out
	);

wire [4:0]	ACC_Ctrl;
wire 		Count_Reg_judge;
ConTrolPath ConTrolPath_inst(
	.Clk 				(Clk),
	.Reset 				(Reset),
	.Load 				(Load),
	.Count_Reg_judge 	(Count_Reg_judge),

	.Done 				(Done),
	.ACC_Ctrl 			(ACC_Ctrl)
	);

Data_Path Data_Path_inst(
	.Data_In 			(Data_In),
	.Clk 				(Clk),
	.Reset 				(Reset),
	.ACC_Ctrl 			(ACC_Ctrl),

	.ACC_Out 			(ACC_Out),
	.Count_Reg_judge 	(Count_Reg_judge)
	);
endmodule