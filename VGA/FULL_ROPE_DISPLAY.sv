//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module FULL_ROPE_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic startOfFrame,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,

			
			//Collision inputs 
			input logic [ROPES-1:0] dirToggle,
			input logic [ROPES-1:0] monkeyCollision,
			//Movement inputs 
			input logic [ROPES-1:0] [6:0] X_SPEED,
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [ROPES-1:0] ropeDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [ROPES-1:0][7:0] ropeRGB,
			
			output logic [ROPES-1:0][31:0] SIGNED_SPEEDS
			
);



//logic [ROPES-1:0][6:0] SPEEDS = {7'b1000000, 7'b1000100, 7'b0001010};


//logic [ROPES-1:0][31:0] SIGNED_SPEEDS;

parameter int LEFT_ROPES = 3;
parameter int RIGHT_ROPES = 3;
parameter int ROPES = 6; 


genvar i;

generate  
	

	for (i = 0; i < LEFT_ROPES; i = i + 1) begin : LEFT_ROPE_DISPLAY_GENERATION
		
		SINGLE_ROPE_DISPLAY rope (
										.clk(clk),
										.resetN(resetN),
										.startOfFrame(startOfFrame),
										.dirToggle(dirToggle[i]),
										.X_SPEED(X_SPEED[i]),
										.INITIAL_X(100),
										.INITIAL_Y(100),
										.pixelX(pixelX),
										.pixelY(pixelY), 
										.ropesDrawingRequest(ropeDR[i]),
										.ropesRGB(ropeRGB[i]),
										.SPEED(SIGNED_SPEEDS[i])
									 );
									 
	end
	
	
	for (i = LEFT_ROPES; i < ROPES; i = i + 1) begin : RIGHT_ROPE_DISPLAY_GENERATION
		
		SINGLE_ROPE_DISPLAY rope (
										.clk(clk),
										.resetN(resetN),
										.startOfFrame(startOfFrame),
										.dirToggle(dirToggle[i]),
										.X_SPEED(X_SPEED[i]),
										.INITIAL_X(400),
										.INITIAL_Y(100),
										.pixelX(pixelX),
										.pixelY(pixelY), 
										.ropesDrawingRequest(ropeDR[i]),
										.ropesRGB(ropeRGB[i]),
										.SPEED(SIGNED_SPEEDS[i])
									 );
									 
	end
	
endgenerate 



endmodule  