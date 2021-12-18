//This module is used to generate NUMBERS amount of random numbers
//-- Zohar Milman Dec 2021 

module RANDOM_GEN (
			input logic clk,
			input logic resetN,
			input logic [NUMBERS-1:0] trigger,
			
		
			output logic [NUMBERS-1:0][3:0] randomNumbers 
);


parameter int NUMBERS = 3;
logic [NUMBERS-1:0] trigger_d;
logic [NUMBERS/3 - 1:0][9:0]  numout;
//We use a for loop to generate NUMBERS amount of random machines

genvar i;

generate

	for (i = 0; i < NUMBERS/3; i = i + 1) begin : RANDOM_MACHINE_GENERATION
		
		
		random #(.SIZE_BITS(10), 
			.MIN_VAL(1), 
			.MAX_VAL(999 - i*7)
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(!trigger[i*3] | !trigger[i*3 + 1] | !trigger[i*3 + 2]),
							  .dout(numout[i]));
	end 
	
endgenerate 

always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			for (int i = 0; i < NUMBERS/3; i = i + 1) begin
				randomNumbers[i*3] <= (numout[i] % 10);
				randomNumbers[i*3 + 1] <= (numout[i] / 10) % 10;
				randomNumbers[i*3 + 2] <= numout[i] / 100;
			end
			trigger_d <= trigger;
		end
		else begin
			trigger_d <= trigger;
			for (int i = 0; i < NUMBERS/3; i = i + 1) begin
				if (trigger[i*3] && !trigger_d[i*3]) randomNumbers[i*3] <= numout[i] % 10;
				if (trigger[i*3 + 1] && !trigger_d[i*3 + 1]) randomNumbers[i*3 + 1] <= (numout[i] / 10) % 10;
				if (trigger[i*3 + 2] && !trigger_d[i*3 + 2]) randomNumbers[i*3 + 2] <= numout[i] / 100;
			end
		end
	
	end

endmodule 
