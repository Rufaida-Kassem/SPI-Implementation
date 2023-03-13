module Master(clk, reset,start, slaveSelect, masterDataToSend, masterDataReceived, SCLK, CS, MOSI, MISO);

//input must be wire  --> lnside the module 
//input can be sedt any type ---> outside the module
//output can be anything iside the module 
//output must be sent as a wire ---> outside the module
//reg ---> initial or always
//wire --> assign
input clk;
input reset;
input start;
input [1:0] slaveSelect;
input [7:0] masterDataToSend;
output reg[7:0] masterDataReceived;
output reg SCLK;
output reg [0:2] CS;
output reg MOSI;
input MISO;
integer count_t, count_r;
//Data sampled on the falling edge  ---> sample = read
//and shifted out on the rising edge

reg state;
reg [7:0] masterDataToSend_temp;

localparam idle = 'b0;
localparam not_idle = 'b1;
localparam PERIOD = 20;
localparam CPOL = 0;

//assign SCLK = clk;
assign SCLK = (state == idle) ? CPOL : clk;

always @ (posedge clk or negedge clk or posedge reset)
begin
if(reset)
begin
CS[0:2] <= 'b111;
MOSI <= 'Z;
masterDataReceived <= 0;
state <= idle;
end
else if(start && state == idle)
begin
state <= not_idle;
count_t <= 0;
count_r <= 0;
masterDataToSend_temp<=masterDataToSend;
if(slaveSelect == 'b00)
begin
CS[0:2] <= 'b011;
end
else if(slaveSelect == 'b01)
begin
CS[0:2] <= 'b101;
end
else if(slaveSelect == 'b10)
begin
CS[0:2] <= 'b110;
end
else
begin
CS[0:2] <= 'b111;
end

repeat (8)
begin 
@ (posedge SCLK)
begin
MOSI <= masterDataToSend_temp[count_t];
count_t <= count_t + 1;
end
@ (negedge SCLK)
begin 
masterDataReceived[count_r] <= MISO;
count_r <= count_r + 1;
end
end
MOSI <= 'Z;
CS <= 'b111;
state <= idle;
end
end
endmodule

//we can use count 
// same data transmitted is recieved
//if we read a bit from right, we recieve it in the right.
