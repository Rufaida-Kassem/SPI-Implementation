module Master_TB();

reg clk; 
reg reset; 
reg start; 
reg [1:0] slaveSelect;
reg [7:0] masterDataToSend;
wire [7:0] masterDataReceived;
wire SCLK; wire [0:2] CS;wire MOSI;

// Here we create an instance of the master
Master UUT_M(
	clk, reset,
	start, slaveSelect, masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MOSI
);
localparam PERIOD = 20;
localparam TESTCASECOUNT = 3;

// These wires will hold the test case data that will be transmitted by the master and TB
wire [7:0] testcase_masterData[2:0];

assign testcase_masterData[0] = 8'b01010011;
assign testcase_masterData[1] = 8'b00111100;
assign testcase_masterData[2] = 8'b11111111;

integer failures, index;

initial begin
	// Initialinzing the variables
	
	failures = 0;
	// Initializing the inputs and reseting the units under test
	clk = 0; // Initialize the clock signal
  	reset = 1; // Set reset to 1 in order to reset all the modules
	start = 0;

	masterDataToSend = 0;
	// Reset Done is done so set reset back to 0 after 1 clock cycle
	#PERIOD reset = 0;
		
		for(index = 1; index <= TESTCASECOUNT; index=index+1) begin
			$display("Running test set %d", index);
			masterDataToSend = testcase_masterData[index - 1]; // Set the data that the master should send
			start = 1; // Set start to 1 to initiate transmission
			#PERIOD start = 0; // Wait for 1 period then set start back to 0
			#(PERIOD*20);
			// Check that the master correctly received the data that should have been sent by the slave
			if(masterDataReceived == masterDataToSend) $display("Exchange between TB and Master: Success");
			else begin
				$display("From TB to Master: Failure (Expected: %b, Received: %b)", masterDataToSend, masterDataReceived);
				failures = failures + 1;
			end
		end
end

// Toggle the clock every half period
always #(PERIOD/2) clk = ~clk;

endmodule
