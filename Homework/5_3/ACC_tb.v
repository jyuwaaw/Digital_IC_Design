module ACC_tb();
reg 		Clk;
reg 		Reset;
reg  [7:0]	Data_In;
reg 		Load;
wire [7:0]	ACC_Out;
wire 		Done;

initial begin
		Clk 	= 0;
		Reset 	= 0;
		Data_In = 0;
		Load	= 0;
#5 		Reset 	= 1;
#100 	Load	= 1;
#10		Load  	= 0; 	
end

always #10 Clk = !Clk;
always #20 Data_In = {$random}%8;
ACC ACC_inst(
	.Data_In 	(Data_In),
	.Clk 		(Clk),
	.Load 		(Load),
	.Reset 		(Reset),

	.ACC_Out 	(ACC_Out), 
	.Done 		(Done)
	);
endmodule