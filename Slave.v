module Slave (
	reset,
	slaveDataToSend, slaveDataReceived,
	SCLK, CS, MOSI, MISO
);
input SCLK;
input reset;
input [7:0] slaveDataToSend;
output reg[7:0] slaveDataReceived;
input CS;
output reg MISO;
input MOSI;
integer count_t, count_r;
integer i;
reg [7:0] slaveDataToSend_temp;
localparam PERIOD = 20;

reg state;
localparam idle = 'b0;
localparam not_idle = 'b1;
always @ (negedge CS or posedge reset)
begin
if(reset)
begin
MISO <= 'Z;
slaveDataReceived <= 0;
state <= idle;
end
else if(CS == 0 && state == idle)
begin
state <= not_idle;
count_t <= 0;
count_r <= 0;
i <= 0;
slaveDataToSend_temp<=slaveDataToSend;

repeat (8)
begin 
@ (posedge SCLK)
begin
MISO <= slaveDataToSend_temp[count_t];  
count_t <= count_t + 1;
end
@ (negedge SCLK)
begin 
slaveDataReceived[count_r] <= MOSI;
count_r <= count_r + 1;
end
end
MISO <= 'Z;
state <= idle;
end
end
endmodule