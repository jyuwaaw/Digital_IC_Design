module vendingMachine(	output can_out,
						output change_out,
						input clk,
						input reset,
						input one_in,
						input half_in);

	wire rst = 1'b1;
	wire rstout;
	reg sel;
	reg [2:0] state, nextstate;

	parameter IDLE		= 3'b000;
	parameter ONELE		= 3'b001;
	parameter HALFLE	= 3'b010;
	parameter CANOUT	= 3'b011;
	parameter CHNGOUT	= 3'b100;

	assign rstout = sel ? rst : reset;

	// State Register
	always @ (posedge clk or posedge rstout) begin
		if (rstout)	state <= IDLE;
		else		state <= nextstate;
	end
	
	always @ (negedge clk) begin
		sel <= (state == CANOUT | state == CHNGOUT);
	end

	// Next State Logic
	always @ (*) begin
		case (state)
			IDLE:	if (one_in & ~half_in)			nextstate = ONELE;
					else if (half_in & ~one_in)		nextstate = HALFLE;
					else							nextstate = IDLE;
			ONELE: 	if (one_in & ~half_in)			nextstate = CHNGOUT;
					else if (half_in & ~one_in)		nextstate = CANOUT;
					else if (~one_in & ~half_in)	nextstate = ONELE;
					else							nextstate = IDLE;
			HALFLE:	if (one_in & ~half_in)			nextstate = CANOUT;
					else if (half_in & ~one_in)		nextstate = ONELE;
					else if (~one_in & ~half_in)	nextstate = HALFLE;
					else							nextstate = IDLE;
			CANOUT:									nextstate = IDLE;
			CHNGOUT:								nextstate = IDLE;
			default:								nextstate = IDLE;
		endcase
	end

	// Output Logic
	assign can_out = (state == CANOUT | state == CHNGOUT);
	assign change_out = (state == CHNGOUT);
endmodule
