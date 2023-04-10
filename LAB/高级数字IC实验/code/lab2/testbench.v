/* timescale = 1ns/1ns 
Keeping Write_Clock frequency = 100 MHz
Read_Clock Frequency = 100 MHz 
*/

module Testbench;

wire [7:0]read_data;
reg read_enable;
reg [7:0]write_data;
reg write_enable;
reg read_clock;
reg write_clock;
reg read_reset;
reg write_reset;
wire empty;
wire full;

complete uut(.read_data(read_data), .read_enable(read_enable), .write_data(write_data), .write_enable(write_enable), .read_clock(read_clock), .write_clock(write_clock), .read_reset(read_reset), .write_reset(write_reset), .empty(empty), .full(full));

initial 
begin
	$dumpfile("Jay.vcd");
    $dumpvars();
	write_clock = 0;
	forever #5 write_clock = ~write_clock;
end
  
initial
begin
	write_enable = 0;
	forever #10 write_enable = ~write_enable;
end

initial
begin
	read_clock = 0;
	forever #5 read_clock = ~read_clock;
end
	
initial
begin
	read_enable = 0;
	forever #10 read_enable = ~read_enable;
end

initial 
begin
	forever #15 write_data = $random;
end

initial 
begin
	write_reset = 1;
	read_reset = 1;
	#5;
      	write_reset = 0;
	read_reset = 0;
	#400;
	$finish;
end
	  
initial 
begin
      	$monitor($time,"\tread_reset = %0b write_clock = %0b read_clock = %0b write_enable = %0b read_enable = %0b, write_data = %0d read_data = %0d", read_reset, write_clock, read_clock, write_enable, read_enable, write_data, read_data);
    	
end

endmodule

