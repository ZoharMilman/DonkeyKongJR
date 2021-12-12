//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module SCORE_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [2:0] [3:0] numbersToShow,
			input logic SignToShow,
			input logic ShowSign,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			
			
			output logic [3:0] scoreDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [3:0] [7:0] scoreRGB
			
);



int j;

parameter int topLeftX = 150;
parameter int topLeftY = 100;
parameter int topLeftXsign = 150;
parameter int topLeftYsign = 100;
parameter int xDiff = 50;
parameter int yDiff = 100;

parameter int NUM_AMOUNT_X = 1; 
parameter int NUM_AMOUNT_Y = 3;
localparam int collums = NUM_AMOUNT_Y;

parameter int NUMBERS = 3;

genvar i;

generate

	for (i = 1; i < NUMBERS+ 1; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
		
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbersToShow[i-1]), 
										.topLeftX(topLeftX + (xDiff * ((i-1) / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.topLeftY(topLeftY + (yDiff * (i % collums))),
										.show(1'b1),
										.numDR(scoreDR[i]),
										.numRGB(scoreRGB[i])
									 );
									 
	end
endgenerate 
OPERAND_DISPLAY plus_display (.clk(clk),
										.resetN(resetN),
										.operandSel(SignToShow),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.topLeftX(topLeftXsign),
										.topLeftY(topLeftYsign),
										.show(ShowSign),
										.operandDR(scoreDR[0]),
										.operandRGB(scoreRGB[0]));

endmodule  