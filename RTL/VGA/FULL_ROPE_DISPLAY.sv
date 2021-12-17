//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module FULL_ROPE_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,

			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic ropeDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [7:0] ropeRGB
			
);




parameter int topLeftX = 150;
parameter int topLeftY = 100;


genvar i;

generate

	for (i = 0; i < 1; i = i + 1) begin : ROPE_DISPLAY_GENERATION
		
		
		SINGLE_ROPE_DISPLAY rope (
										.clk(clk),
										.resetN(resetN),
										.pixelX(pixelX),
										.pixelY(pixelY), 
										.topLeftX(topLeftX),  
										.topLeftY(topLeftY),
										.ropesDrawingRequest(ropeDR),
										.ropesRGB(ropeRGB)
									 );
									 
	end
endgenerate 


endmodule  