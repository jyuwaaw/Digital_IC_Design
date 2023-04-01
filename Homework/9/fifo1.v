module FIFO_IF1
(
input clk_1,
input reset,
input req,
input [3:0]data,
input wfull,
output reg IF1_req,
output reg [3:0]IF1_data
);


reg [3:0] current_state,next_state;


parameter
IDLE = 4'd0,
REQ_ACTIVE = 4'd1,
REQ_RELEASE = 4'd2;


always@(posedge clk_1 or negedge reset)
begin
if(!reset)
current_state <= IDLE;
else
current_state <= next_state;
end


always@(*)
begin
next_state = IDLE;
case(current_state)
IDLE :
begin
IF1_req = 1'b0;
next_state = REQ_ACTIVE;
end
REQ_ACTIVE :
begin
if(wfull)
begin
IF1_req = 1'b0;
IF1_data = IF1_data;
next_state = REQ_ACTIVE;
end
else if(req)
begin
IF1_data = data;
IF1_req = 1'b1;
next_state = REQ_RELEASE;
end
else
begin
IF1_req = 1'b0;
next_state = REQ_ACTIVE;
end
end
REQ_RELEASE :
begin
if(!req)
next_state = REQ_ACTIVE;
else
begin
IF1_req = 1'b0;
next_state = REQ_RELEASE;
end
end
default :
next_state = IDLE;
endcase
end


endmodule

