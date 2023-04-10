/*
Making a big block (complete) for the asynchronous fifo.
this big block consists of:
1. Writing Block
2. binary to gray code converter
3. memory element
4. gray code to binary converter
5. Reading lock
6. write to read synchronizer
7. Read to write synchronizer
*/
module complete(read_data, read_enable, write_data, write_enable, read_clock, write_clock, read_reset, write_reset, empty, full);
//declaring the input and output terminals.
output [7:0]read_data;
input read_enable;
input [7:0]write_data;
input write_enable;
input read_clock;
input write_clock;
input read_reset;
input write_reset;
output empty;
output full;
//different nets used to store value in the device
wire [2:0]binary_in;
wire [2:0]binary_out;
wire [2:0]write_count;
wire [2:0]read_count;
wire [3:0]write_pointer;
wire [3:0]read_pointer;
//calling the memory module
asynchronous_fifo asynchronous_fifo(.read_data(read_data), .read_enable(read_enable), .write_data(write_data), .write_enable(write_enable), .read_clock(read_clock), .write_clock(write_clock), .read_reset(read_reset), .write_reset(write_reset), .empty(empty), .full(full));
//calling the read to write synchronizer module
read_to_write read_to_write(.w2r_pointer(w2r_pointer), .read_pointer(read_pointer), .write_clock(write_clock), .write_reset(write_reset));
//calling the write to read synchronizer module
write_to_read write_to_read(.r2w_pointer(r2w_pointer), .write_pointer(write_pointer), .read_clock(read_clock), .read_reset(read_reset));

endmodule

//module defined for the memory element. this module containd all the inputs
//from the write block which then converted to the gray code and the these
//gray code counter values are converted back to the binary no. for the output
//read data.
module asynchronous_fifo(read_data, read_enable, write_data, write_enable, read_clock, write_clock, read_reset, write_reset, empty, full);
//declaring inputs and outputs for the memory element.
output logic [7:0]read_data;
input logic read_enable;
input logic [7:0]write_data;
input logic write_enable;
input logic read_clock;
input logic write_clock;
input logic read_reset;
input logic write_reset;
output logic empty;
output logic full;
//declaration of registers to store old/previous values.
reg [7:0]memory[0:7];
bit [2:0]write_count;
bit [2:0]read_count;
bit [2:0]binary_in;
bit [2:0]binary_out;
//whenever the positive edge of the write_clock will occur then inside
//statements will execute. 
always@(posedge write_clock)
begin
//till the write_reset is 'HIGH' there will be no writing operation.
	if(write_reset)
	begin
//if write_reset is 'HIGH' there will be empty state. as stated earlier there
//will be no writing operation therefore the counter is still empty.
		empty <= 1;		//non-blocking because it comes under the memory device (sequential)
      		$display("empty = 1");
	end
//when write_reset is 'LOW' then the following statements will execute.
	else 
	begin
//if write_enable is 'HIGH' then only writing is done. otherwise the
//write_count will keep its previous value.
		if(write_enable)
		begin
//the maximum limit of the meory for write_count and the read_count is 8(0 to
//7). if the limit is exceeded then only this if block will not be accessed. 
			if(binary_in < 8)
			begin	
//storing write_data (input) inside a memory location with binary count. now
//this count has to be converted into the gray count.
              			memory[binary_in] = write_data;			//blocking because it is outside the sequential device
				$display("write_data = %0d", write_data);
//converting the binary_in count into gray-code for avoiding the
//metastability. after 111 the counter goes back to 000. so, we can see there
//is a change of all three bits here so, this is not good for operation. so
//that we are using gray codes because there is only one bit change.
           			write_count[0] = binary_in[1]^binary_in[0];
              			write_count[1] = binary_in[2]^binary_in[1];
              			write_count[2] = binary_in[2];
				$display("binary_in = %0d", binary_in);
				$display("write_count = %0d", write_count);
//now the binary count value is stored inside the gray count value.               			
				memory[write_count] <= memory[binary_in]; 	//non-blocking because coming under the sequential circuit.
              /*$display("write_memory[%0d] = %0d",write_count, memory[write_count]);*/
//the write_count and the read_count are made equal so that the correct values
//will be stored at correct places.
				read_count = write_count;			//not a matter of sequential thing
//value at write_count is stored to read_count.
              			memory[read_count] <= memory[write_count];	//using non-blocking assignment because this action is execcuted inside the memory (sequential) device.
              /*$display("read_memory[%0d] = %0d",read_count, memory[read_count]);*/
			end
//if binary count goes above its limit the the full signal will get 'HIGH' and
//will give a warning.
			else
			begin
				full <= 1;					//coming under the sequential circuit.
              			$display("memory counter is full");
			end
//after storing value at one place the value of binary count is incremented by
//1 and the previous actions will again executed.
			binary_in = binary_in + 1;				//outside of the sequential circuit
        	end
//if write_enable is 'LOW' then the memory will keep its previous value.
      		else
		begin
	              memory[write_count] <= memory[write_count];		//inside the sequential circuit
		end
	end	
end

//all the inside actions will execute only when the positive edge of th
//read_clock comes.
always@(posedge read_clock)
begin
//till the read_reset is 'HIGH' there will be no writing operation.
	if(read_reset)
	begin
//hence the output read data wvalue will be 0 by default.
		read_data <= 0;							//outside of memory device
	end
	else
	begin
//if read_enable is 'HIGH' then only the reading option will got active.
		if(read_enable)
		begin
//if binary_out counter value goes above its limit will is 8 in counting(0 to
//7) then following actions will not be executed.
			if(binary_out < 8)
			begin
//gray code is converted to binary. read_count was in gray code and now its
//binary conversion is stored in the binary_out.
            			binary_out[0] = read_count[2]^read_count[1]^read_count[0];
              			binary_out[1] = read_count[2]^read_count[1];
              			binary_out[2] = read_count[2];
				$display("binary_out = %0d", binary_out);
//this value in gray count will get stored in space for binary count.
              			memory[binary_out] <= memory[read_count];	//transaction happening under the memory device
              			$display("memory[%0d] = %0d",binary_out, memory[binary_out]);
//the value at binary count will come to output.
				read_data = memory[binary_out];			//transaction done outside the memory device
				$display("read_data = %0d", read_data);
			end
//if the binary_out count limits exceeds i.e. the counter is empty now.
			else
			begin
				empty <= 1;					//logic used inside the memory device.
              			$display("memory counter is empty");
			end
//the binary count value will get incremented after going through/executing all the
//statements.
			binary_out = binary_out + 1;				//action outside the memory device
		end
//if read_enable is 'LOW' then the memory will keep its value which it had at
//binary count.
		else
		begin
          		memory[binary_out] <= memory[binary_out];		//non-blocking because it is done inside the memory device 
		end
	end
end

endmodule

//read to write synchronizer which uses the 2 flip-flop synchronization. value
//at read counter will get stored with respect to the write clock. 

module read_to_write(w2r_pointer, read_pointer, write_clock, write_reset);
//declaring the read pointers and the write clock with write reset.
output [3:0]w2r_pointer;
input [3:0]read_pointer;
input write_clock, write_reset;

reg [3:0]w2r_pointer;
reg [3:0]w2r_pointer0;
//reading values only when the positive edge of the write clock appears.
always@(posedge write_clock)
begin
//it also depends on the write_reset. the pointers will become 0 when reset is
//'HIGH'.
	if(write_reset)
	begin
		w2r_pointer <= 0;
		w2r_pointer0 <= 0;
	end
//otherwise the value will for pointers will be the previous value and the
//value of read pointer.
	else
	begin
		w2r_pointer <= w2r_pointer0;
		w2r_pointer0 <= read_pointer;
	end
end

endmodule
//write to read synchronizer which uses the 2 flip-flop synchronization. value
//at write counter will get stored with respect to the read clock.  
module write_to_read(r2w_pointer, write_pointer, read_clock, read_reset);
//declaring the write pointers and the read clock with the read reset.
output [3:0]r2w_pointer;
input [3:0]write_pointer;
input read_clock, read_reset;

reg [3:0]r2w_pointer;
reg [3:0]r2w_pointer0;
//writing values only when the positive edge of the read clock appears.
always@(posedge read_clock)
begin
//it also depends on the read_reset. the pointers will become 0 when reset is
//'HIGH'.
	if(read_reset)
	begin
		r2w_pointer <= 0;
		r2w_pointer0 <= 0;
	end
//otherwise the value for the pointers will be the previous value and the
//value for the write pointer.
	else
	begin
		r2w_pointer <= r2w_pointer0;
		r2w_pointer0 <= write_pointer;
	end
end

endmodule

/*

LOGIC FOR BINARY TO GRAY CODE CONVERTER

module binary_to_gray(o3, o2, o1, i3, i2, i1);
  
  output o3, o2, o1;
  input i3, i2, i1;
  
  assign o3 = i3;
  assign o2 = i3^i2;
  assign o1 = i2^i1;
  
endmodule

LOGIC FOR GRAY CODE TO BINARY CONVERTER

module gray_to_binary(b3, b2, b1, g3, g2, g1);
  
  output b3, b2, b1;
  input g3, g2, g1;
  
  assign b3 = g3;
  assign b2 = g3^g2;
  assign b1 = g3^g2^g1;
  
endmodule

LOGIC FOR 2 FLIP-FLOP SYNCHRONIZER

module synchronization(q, d, clock, reset);

output q;
input d, clock, reset;

reg q0, q;

always@(posedge clock)
begin
	if(reset)
	begin
		q <= 0;
		q0 <= 0;
	end
	else
	begin
		q <= q0;
		q0 <= d;
	end
end

endmodule

*/
