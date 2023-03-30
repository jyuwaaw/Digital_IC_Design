//Author：1914020208hyh
//Date: 2022.5.10 16:28
module advhw7_3_PCS_demo(
    input b_in,
    input clk1,
    input rst,
    output frame_clk,
    output req,
    output reg [3:0] data
);

reg	reg_buffer;			//reg control signal 
reg	ena;
reg	cnt, clk_F;
reg	[3:0]	data_valid;	//for valid data 
reg	[4:0]	cs,ns;	//for FSM
reg	[6:0]	data_temp;	//shift_register

//Specs of the FSM
//In order to recognize 4 sequential 4'b1111, Requires 4x4+1(IDLE)=17 States in FSM 
parameter	IDLE = 5'b00000, s0 = 5'b00001, s1 = 5'b00010, s2 = 5'b00011, s3 = 5'b00100,s4 = 5'b00101;
parameter	s5 = 5'b00110, s6 = 5'b00111, s7 = 5'b01000, s8 = 5'b01001,s9 = 5'b01010, s10 = 5'b01011;
parameter	s11 = 5'b01100, s12 = 5'b01101, s13 = 5'b01110, s14 = 5'b01111,s15 = 5'b10000, s16 = 5'b10001;
							
//Clock specs |  
always @(posedge clk1 or posedge rst)
begin
	if(rst)
		cnt <= 1'b0;
	else if(cnt == 1)
		cnt <= 1'b0;
	else	
		cnt <= cnt + 1'b1;
end

always @(posedge clk1 or posedge rst)
begin
	if(rst)
		clk_F <= 1'b0;
	else if(cnt == 1)
		clk_F <= ~clk_F;
	else
		clk_F <= clk_F;
end

assign frame_clk = clk_F;

//Finite State Machine
//State Transfer
always @(posedge clk1 or posedge rst)
begin
	if(rst)
		cs <= IDLE;
	else
		cs <= ns;
end

//Main
always @(*)
begin
	ns = IDLE;
case(cs)
	IDLE	:	
		begin
			if(rst)
				ns = IDLE;
			else
				ns = s0;
		end
//Beginning of sequence 4'b1111 detect 	
	s0:
		begin
			if(b_in)
				ns = s1;
			else
				ns = s0;
		end
	s1:
		begin
			if(b_in)
				ns = s2;
			else
				ns = s0;
		end
	s2:
		begin
			if(b_in)
				ns = s3;
			else
				ns = s0;
		end
	s3:
		begin
			if(b_in)
				ns = s4;
			else
				ns = s0;
		end
//End of sequence 4'b1111 detect 	

	s4	:	ns = s5;
	s5	:	ns = s6;
	s6	:	ns = s7;
	s7	:	ns = s8;
	s8	:	ns = s9;
	
//Previous 5bits loaded, now comes to latter bits
	s9	:	begin
		if(data_temp [3:0] == 4'b1111)	
			ns = s14;
		else
			ns = s10;
	end
	s10	:	begin
		if(data_temp [3:0] == 4'b1111)
			ns = s15;
		else
			ns = s11;
	end
	s11	:	begin
		if(data_temp [3:0] == 4'b1111)
			ns = s16;
		else
			ns = s12;
	end
	s12	:	begin
		if(data_temp [3:0] == 4'b1111)
			ns = s13;
		else
			ns = s9;
	end
//Up till here 4 bits loaded, back to s9

	s13	:	ns = s14;
	s14	:	ns = s15;
	s15	:	ns = s16;
//Use {} to combine the LSB of "data_temp" with "b_in" to countinue Sequence detect of 4'b1111	
	s16	:	begin
		if({data_temp[2:0], b_in} == 4'b1111)
			ns = s4;
		else if({data_temp[1:0], b_in} == 3'b111)
			ns = s3;
		else if ({data_temp[0], b_in} == 2'b11)
			ns = s2;
		else
			ns = s0;	//1 bit of 1 situation already declared in previous scopes
	end
endcase
end

//ena signal control & valid output data
always @(posedge clk1 or posedge rst)
begin
	if(rst)
		begin
			data_temp <= 7'b000_0000;
			ena <= 1'b0;
		end
	else
		begin
			//assign data_temp = {data_temp[5:0], b_in};
				case(ns)	
					s4		:	begin
									data_temp	<=	{data_temp[5:0], b_in};
									ena <= 1'b0;
									end
					s12	:	begin
									data_temp	<=	{data_temp[5:0], b_in};
									ena <= 1'b1;
									data_valid	<=	data_temp[6:3];	//Currently valid bits are 6,5,4,3
									end
					s16	:	begin
									data_temp	<=	{data_temp[5:0], b_in};
									ena <= 1'b0;
									end
					default	:	begin
												//ena	<=	1'b0;
												data_temp = {data_temp[5:0], b_in};
											end
				endcase
		end
end

/*
always@(posedge clk1 or posedge rst)
begin
if(rst)
begin
data_temp <= 7'b0000000;
ena <= 1'b0;
end

else
begin
case(ns)
s4 :
begin
data_temp <= {data_temp[5:0],b_in};
ena <= 1'b0;
end

s5 : 
data_temp <= {data_temp[5:0],b_in};

s6 :
data_temp <= {data_temp[5:0],b_in};

s7 :
data_temp <= {data_temp[5:0],b_in};

s8 :
data_temp <= {data_temp[5:0],b_in};

s9 :
data_temp <= {data_temp[5:0],b_in}; 

s10 :
data_temp <= {data_temp[5:0],b_in};

s11 :
data_temp <= {data_temp[5:0],b_in};

s12 :
begin
data_temp <= {data_temp[5:0],b_in};
data_valid <= data_temp[6:3];
ena <= 1'b1;
end
s13 :
begin
data_temp <= {data_temp[5:0],b_in};
ena <= ena;
end
s14 :
begin
data_temp <= {data_temp[5:0],b_in};
ena <= ena;
end
s15 :
begin
data_temp <= {data_temp[5:0],b_in};
ena <= ena;
end
s16 :
begin
data_temp <= {data_temp[5:0],b_in};
ena <= 1'b0;
end
default : 
begin
data_temp <= {data_temp[5:0],b_in};
ena <= 1'b0;
end
endcase
end
end
*/
//Export results of FSM
always @(posedge clk_F or posedge rst)
begin
	if(rst)
		begin
			data	<=	4'b0000;
			reg_buffer	<=	1'b0;
		end
	else if(ena)
		begin
			data	<=	data_valid;
			reg_buffer	<=	1'b1;		//Now the 2 state of reg_buffer have been stated
		end
	else
		begin
			data	<= data;
			reg_buffer	<=	1'b0;
		end
end

assign req	=	clk_F	&	reg_buffer;		//Fullfill the need that req is pullup only when both Frame_clk and data are active
	
endmodule
	