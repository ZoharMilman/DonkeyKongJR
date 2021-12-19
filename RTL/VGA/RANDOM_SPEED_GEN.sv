//This module is used to generate NUMBERS amount of random numbers
//-- Zohar Milman Dec 2021 

module RANDOM_SPEED_GEN (
			input logic clk,
			input logic resetN,
			input logic trigger,
			
		
			output logic [ROPES-1:0][6:0] X_SPEED
);


parameter int LEFT_ROPES = 3;
parameter int RIGHT_ROPES = 3;
parameter int ROPES = 6;

//We use a for loop to generate NUMBERS amount of random machines

genvar i;

generate

for (i = 0; i < LEFT_ROPES; i = i + 1) begin : LEFT_RANDOM_MACHINE_GENERATION
		
		random #(.SIZE_BITS(7), 
			.MIN_VAL(45), 
			.MAX_VAL(70 + (7 * i))
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(trigger),
							  .dout(X_SPEED[i]));
									 
end
	
for (i = LEFT_ROPES; i < ROPES; i = i + 1) begin : RIGHT_RANDOM_MACHINE_GENERATION
		
		random #(.SIZE_BITS(7), 
			.MIN_VAL(45 + (7 * (i - LEFT_ROPES))), 
			.MAX_VAL(70)
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(trigger),
							  .dout(X_SPEED[i]));
									 
end  	
endgenerate 

endmodule 
