//This module is used to generate NUMBERS amount of random numbers
//-- Zohar Milman Dec 2021 

module RANDOM_GEN (
			input logic clk,
			input logic resetN,
			input logic trigger,
			
		
			output logic [NUMBERS-1:0][3:0] randomNumbers 
);


parameter int NUMBERS = 3;
//We use a for loop to generate NUMBERS amount of random machines

genvar i;

generate

	for (i = 0; i < NUMBERS; i = i + 1) begin : RANDOM_MACHINE_GENERATION
		
		
		random #(.SIZE_BITS(4), 
			.MIN_VAL((i + 1) % 10), 
			.MAX_VAL(9)
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(trigger),
							  .dout(randomNumbers[i]));
	end 
	
endgenerate 



endmodule 
