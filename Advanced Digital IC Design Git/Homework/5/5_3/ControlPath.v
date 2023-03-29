module ConTrolPath(
	input 				clk,
	input 				rst_n,
	input 				Load,
	input 				Count_Reg_judge,

	output reg			Done,
	output reg	[4:0]	ACC_Ctrl
	);
//==================================
//define resgister & wire 
reg 	[4:0]	c_state; 	//current_state
reg 	[4:0]	n_state;	//next_state
//==================================

//==================================
//define state
localparam IDLE = 5'b00001; 	//initial all register of data_path
localparam S1 	= 5'b00010;		//set the the amount of data 
localparam S2 	= 5'b00100;		//adder working 
localparam S3 	= 5'b01000;		//counter working 
localparam S4 	= 5'b10000;		//state when adder do not work

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		c_state <= IDLE; 
	end
	else begin
		c_state <= n_state;
	end
end

always @(*) begin
	if (!rst_n) begin
		ACC_Ctrl = 5'b00; 
		n_state = IDLE;
	end
	else begin
		case(c_state)
			 	IDLE:	
			 		begin
			 			if (Load) begin
			 				n_state = S1;
			 			end
			 			else begin
			 				n_state = IDLE;
			 			end
			 		end	
				S1 	:
					begin
						n_state = S2;			
					end		
				S2 	:
					begin
						n_state = S3;	
					end		
				S3 	:
					begin
						if (!Count_Reg_judge) begin
							n_state = S4;
						end
						else begin
							n_state = S2;
						end
					end
				S4 	:
					begin
						n_state = S4;				
					end			
				default:n_state = IDLE;
		endcase
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		ACC_Ctrl 	<= 5'b00000;
		Done		<= 0;
	end
	else if (n_state == IDLE) begin
		ACC_Ctrl 	<= 5'b00000;
		Done		<= 0;
	end
	else if (n_state <= S1) begin
		ACC_Ctrl	<= 5'b10111;
		Done		<= 0;
	end
	else if (n_state <= S2) begin
		ACC_Ctrl	<= 5'b01111;
		Done		<= 0;
	end
	else if (n_state <= S3) begin
		ACC_Ctrl	<= 5'b10100;
		Done		<= 0;
	end
	else if (n_state <= S4) begin
		ACC_Ctrl	<= 5'b11111;
		Done		<= 1;
	end

end
endmodule