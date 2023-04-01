module FIFO_IF2
(
input clk_2,
input reset,
input IF2_req,
input [3:0]IF2_data,
input rempty,
output reg req,
output reg [3:0]data
);


reg [3:0] current_state,next_state;


parameter
IDLE = 4'd0,
ACTIVE1 = 4'd1,
EMPTY = 4'd2;


always@(posedge clk_2 or negedge reset)
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
next_state = ACTIVE1;
end
ACTIVE1 :
begin
if(rempty)
next_state = EMPTY;
else if(IF2_req == 1) 
begin
data = IF2_data;
req = IF2_req;
next_state = ACTIVE1;
end
else
begin
data = data;
req = req;
next_state = ACTIVE1;
end
end
EMPTY :
begin
data = IF2_data;
req = IF2_req;
if(!rempty)
next_state = ACTIVE1;
else;
end
default :
next_state = IDLE;
endcase
end

endmodule