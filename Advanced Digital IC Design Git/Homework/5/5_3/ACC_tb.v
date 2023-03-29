module ACC_tb();
reg 		clk;
reg 		rst_n;
reg  [7:0]	Data_In;
reg 		Load;
wire [7:0]	ACC_Out;
wire 		Done;

initial begin
	clk 	= 0;
	rst_n 	= 0;
	Data_In = 0;
	Load	= 0;
#5 	rst_n 	= 1;
#100 	Load	= 1;
#10		Load  	= 0; 	
end

always #10 clk = !clk;
initial	begin

#20 Data_In = 8'b0000_0001;
#20 Data_In = 8'b0000_0010;
#20 Data_In = 8'b0000_0100;
#20 Data_In = 8'b0000_1000;

#20 Data_In = 8'b1000_0001;
#20 Data_In = 8'b0010_0010;
#20 Data_In = 8'b0001_0100;
#20 Data_In = 8'b0100_1000;

#20 Data_In = 8'b0000_0001;
#20 Data_In = 8'b0000_0010;
#20 Data_In = 8'b0000_0100;
#20 Data_In = 8'b0000_1000;

#20 Data_In = 8'b0000_0001;
#20 Data_In = 8'b0000_0010;
#20 Data_In = 8'b0000_0100;
#20 Data_In = 8'b0000_1000;


#20 Data_In = 8'b1000_0001;
#20 Data_In = 8'b00100_0010;
#20 Data_In = 8'b0100_0100;
#20 Data_In = 8'b1000_1000;

#20 $stop;
end
//always #20 Data_In = {$random}%8;
ControlPath ControlPath(
	.clk 				(clk),
	.rst_n 				(rst_n),
	.Load 				(Load),
	.count_eq_z 	(count_eq_z),

	.Done 				(Done),
	.ACC_Ctrl 			(ACC_Ctrl)
	);

Data_Path Data_Path(
	.Data_In 			(Data_In),
	.clk 				(clk),
	.rst_n 				(rst_n),
	.ACC_Ctrl 			(ACC_Ctrl),

	.ACC_Out 			(ACC_Out),
	.count_eq_z 	(count_eq_z)
	);

endmodule
