//This module uses a for loop to create a few number and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module MULTIPLE_NUMBERS_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			
			
			//Collision inputs
			input logic singleHit
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [11:0] drawingRequest, //output that the pixel should be dispalyed 
			output logic [11:0] [7:0] RGBout	
);



//TODO add support for random number generation




//An array that contains for each number its location. 
logic [11:0] [21:0] positions = {
	{11'd150, 11'd150},
	{11'd150, 11'd200},
	{11'd150, 11'd250},
	{11'd200, 11'd150},
	{11'd200, 11'd200},
	{11'd200, 11'd250},
	{11'd250, 11'd150},
	{11'd250, 11'd200},
	{11'd250, 11'd250},
	{11'd300, 11'd150},
	{11'd300, 11'd200},
	{11'd300, 11'd250}
};



//For loop to create 12 Number instances 
genvar i;

generate

	for (i = 0; i < 12; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
	
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(4'b0000), 
										.topLeftX(positions[i][21:11]),
										.topLeftY(positions[i][11:0]),
										.numDR(drawingRequest[i]),
										.numRGB(RGNout[i])
									 );
									 
	end
endgenerate 



endmodule  