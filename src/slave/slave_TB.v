
module Slave_TB();

reg clk;
reg reset;
reg [7:0] slaveDataToSend; 
wire [7:0] slaveDataReceived;
reg CS;
wire MISO;

// Here we create an instance of the slave
Slave UUT_S(
	reset,
	slaveDataToSend, slaveDataReceived,
	clk, CS, MISO, MISO
);
localparam PERIOD = 20;
// How many test cases we have
localparam TESTCASECOUNT = 3;



// These wires will hold the test case data that will be transmitted by the TB and slaves
wire [7:0] testcase_slaveData[2:0];

assign testcase_slaveData[0] = 8'b10101010;
assign testcase_slaveData[1] = 8'b11110000;
assign testcase_slaveData[2] = 8'b00110011;

integer failures, index;

initial begin
	// Initialinzing the variables
	failures = 0;
	clk = 0; // Initialize the clock signal
  	reset = 1; // Set reset to 1 in order to reset all the modules
	CS = 1;

	slaveDataToSend = 0;
	// Reset Done is done so set reset back to 0 after 1 clock cycle
	#PERIOD reset = 0;
	
		// Set the data that the master should send
		for(index = 1; index <= TESTCASECOUNT; index=index+1) begin

			$display("Running test set %d", index);
			slaveDataToSend = testcase_slaveData[index - 1];   // Set the data that the slave should send
			#(PERIOD*20);
			// Check that the master correctly received the data that should have been sent by the slave
			if(slaveDataReceived == slaveDataToSend) $display("Exchange between TB and Slave: Success");
			else begin
				$display("Between TB and Slave: Failure (Expected: %b, Received: %b)", slaveDataToSend, slaveDataReceived);
				failures = failures + 1;
			end
		end
end

// Toggle the clock every half period
always #(PERIOD/2) clk = ~clk;
always #PERIOD CS = ~CS;

endmodule
