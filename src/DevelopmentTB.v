module DevelopmentTB();

reg clk; // Clock which is sent from the testbench to the master.
reg reset; // Reset which is sent from the testbench to all the modules.
reg start; // This signals the master to start the transmission (also the master will read "masterDataToSend" in order to send it to the slave).
reg [1:0] slaveSelect; // This tells the master which slave to transmit to. It should be read by the master when "start" becomes high.
reg [7:0] masterDataToSend; // What data should the master send to the slave during the transmission
wire [7:0] masterDataReceived; // What data did the master receive from the slave during the past transmission
reg [7:0] slaveDataToSend [0:2]; // What data should the slave send to the master during the transmission
wire [7:0] slaveDataReceived [0:2]; // What data did the slave receive from the master during the past transmission
wire SCLK; // The clock generated by the master for the transmission. The master uses the "clk" to generate this signal. Both the master and the slave can only use this signal for synchronizing the transmission. 
wire [0:2] CS; // The chip select signal used by the master to select a slave. If a slave is selected, the master should set its corresponding CS to 0 (active low).
wire MOSI; // The data signal going from the master to the slave.
wire MISO; // The data signal going from the slave to the master.

// Here we create an instance of the master
Master UUT_M(
	clk, reset,
	start, slaveSelect, masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MISO
);
// Here we create 3 instances of the slave
Slave UUT_S0(
	reset,
	slaveDataToSend[0], slaveDataReceived[0],
	SCLK, CS[0], MOSI, MISO
);
Slave UUT_S1(
	reset,
	slaveDataToSend[1], slaveDataReceived[1],
	SCLK, CS[1], MOSI, MISO
);
Slave UUT_S2(
	reset,
	slaveDataToSend[2], slaveDataReceived[2],
	SCLK, CS[2], MOSI, MISO
);

// The period of 1 clock cycle of the "clk"
localparam PERIOD = 20;
// How many test cases we have
localparam TESTCASECOUNT = 2;

// These wires will hold the test case data that will be transmitted by the master and slaves
wire [7:0] testcase_masterData [1:TESTCASECOUNT];
wire [7:0] testcase_slaveData  [1:TESTCASECOUNT][0:2];

assign testcase_masterData[1] = 8'b01010011;
assign testcase_slaveData[1][0] = 8'b00001001;
assign testcase_slaveData[1][1] = 8'b00100010;
assign testcase_slaveData[1][2] = 8'b10000011;

assign testcase_masterData[2] = 8'b00111100;
assign testcase_slaveData[2][0] = 8'b10011000;
assign testcase_slaveData[2][1] = 8'b00100101;
assign testcase_slaveData[2][2] = 8'b11000010;

// index will be used for looping over test cases
// failures will store the number of failed test cases
integer index, failures;