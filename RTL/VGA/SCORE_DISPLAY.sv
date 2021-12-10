//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module SCORE_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [2:0] [3:0] numbersToShow,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			
			
			output logic [2:0] numbersDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [2:0] [7:0] numbersRGB
			
);



int j;

parameter int topLeftX = 150;
parameter int topLeftY = 100;
parameter int xDiff = 50;
parameter int yDiff = 100;

parameter int NUM_AMOUNT_X = 1; 
parameter int NUM_AMOUNT_Y = 3;
localparam int collums = NUM_AMOUNT_Y;

parameter int NUMBERS = 3;

genvar i;

generate

	for (i = 0; i < NUMBERS; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
		
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbersToShow[i]), 
										.topLeftX(topLeftX + (xDiff * (i / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.topLeftY(topLeftY + (yDiff * (i % collums))),
										.show(1'b1),
										.numDR(numbersDR[i]),
										.numRGB(numbersRGB[i])
									 );
									 
	end
endgenerate 


endmodule  