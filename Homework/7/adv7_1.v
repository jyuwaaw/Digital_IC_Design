module advhw7_1(
input data,
input clk_to_domain,
output data_sync
);

reg DFF1,Dff2;

always@(posedge clk_to_domain)
begin
DFF1 <= data;
DFF2 <= DFF1;
end

assign data_sync = DFF2;

endmodule