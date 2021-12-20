//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module SCORE_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [8:0] [3:0] numbersToShow,
			input logic SignToShow,
			input logic ShowSign,
			input logic WIN,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			
			
			output logic [9:0] scoreDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [9:0] [7:0] scoreRGB,
			output logic  WINDR,
			output logic [7:0] WINRGB
			
);



int j;

parameter int topLeftX = 150;
parameter int topLeftY = 100;
parameter int scoretopLeftX = 150;
parameter int scoretopLeftY = 100;
parameter int signtopLeftX = 150;
parameter int signtopLeftY = 100;
parameter int timertopLeftX = 150;
parameter int timertopLeftY = 100;
parameter int wintopLeftX = 150;
parameter int wintopLeftY = 100;
parameter int xDiff = 50;
parameter int yDiff = 100;
parameter int NUM_AMOUNT_X = 1; 
parameter int NUM_AMOUNT_Y = 3;
localparam int collums = NUM_AMOUNT_Y;

parameter int NUMBERS = 3;

genvar i;

generate

	for (i = 1; i < 4; i = i + 1) begin : GOAL_DISPLAY_GENERATION
		
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.startOfFrame(1'b0), //Because these numbers dont have to move, we can treat them as if there is no start of frame.
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbersToShow[i-1]), 
										.X_SPEED(0),
										.INITIAL_X(scoretopLeftX + (xDiff * ((i-1) / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.INITIAL_Y(scoretopLeftY + (yDiff * (i % collums))),
										.show(1'b1),
										.numDR(scoreDR[i]),
										.numRGB(scoreRGB[i])
									 );
									 
	end

	for (i = 4; i < 7; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
		
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.startOfFrame(1'b0), //Because these numbers dont have to move, we can treat them as if there is no start of frame.
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbersToShow[i-1]), 
										.X_SPEED(0),
										.INITIAL_X(topLeftX + (xDiff * ((i-4) / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.INITIAL_Y(topLeftY + (yDiff * (i % collums))),
										.show(1'b1),
										.numDR(scoreDR[i]),
										.numRGB(scoreRGB[i])
									 );
									 
	end

	for (i = 7; i <10; i = i + 1) begin : TIMER_DISPLAY_GENERATION
		
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.startOfFrame(1'b0), //Because these numbers dont have to move, we can treat them as if there is no start of frame.
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbersToShow[i-1]), 
										.X_SPEED(0),
										.INITIAL_X(timertopLeftX + (xDiff * ((i-4) / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.INITIAL_Y(timertopLeftY + (yDiff * (i % collums))),
										.show(1'b1),
										.numDR(scoreDR[i]),
										.numRGB(scoreRGB[i])
									 );
	end
endgenerate 

OPERAND_DISPLAY sign_display (.clk(clk),
										.resetN(resetN),
										.operandSel(SignToShow),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.topLeftX(signtopLeftX),
										.topLeftY(signtopLeftY),
										.show(ShowSign),
										.operandDR(scoreDR[0]),
										.operandRGB(scoreRGB[0])
										);


WIN_DISPLAY victory_display  (.clk(clk),
										.resetN(resetN),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.topLeftX(wintopLeftX),
										.topLeftY(wintopLeftY),
										.show(WIN),
										.WINDR(WINDR),
										.WINRGB(WINRGB)
										);

endmodule  