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
			input logic singleHit,
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [11:0] numbersDR, //output that the pixel should be dispalyed 
			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [11:0] [7:0] numbersRGB
			
);



//TODO add support for random number generation




//An array that contains for each number its location. 



//logic [0:11] [0:1] [0:11] positions = 
//{
//	{11'd150, 11'd150},
//	{11'd150, 11'd200},
//	{11'd150, 11'd250},
//	{11'd200, 11'd150},
//	{11'd200, 11'd200},
//	{11'd200, 11'd250},
//	{11'd250, 11'd150},
//	{11'd250, 11'd200},
//	{11'd250, 11'd250},
//	{11'd300, 11'd150},
//	{11'd300, 11'd200},
//	{11'd300, 11'd250}
//};

//logic [0:1] [0:11] [0:11] positions = {
//	{11'd150, 11'd150},
//	{11'd150, 11'd200},
//	{11'd150, 11'd250},
//	{11'd200, 11'd150},
//	{11'd200, 11'd200},
//	{11'd200, 11'd250},
//	{11'd250, 11'd150},
//	{11'd250, 11'd200},
//	{11'd250, 11'd250},
//	{11'd300, 11'd150},
//	{11'd300, 11'd200},
//	{11'd300, 11'd250}
//};



//For loop to create 12 Number instances 

parameter int topLeftX = 150;
parameter int topLeftY = 100;
parameter int xDiff = 50;
parameter int yDiff = 50;


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
										.topLeftX(topLeftX + (xDiff * (i / 4))),
										.topLeftY(topLeftY + (yDiff * (i % 4))),
										.numDR(numbersDR[i]),
										.numRGB(numbersRGB[i])
									 );
									 
	end
endgenerate 

assign anyNumDR = (numbersDR[0] || numbersDR[1] || numbersDR[2] || numbersDR[3] || numbersDR[4]
					 || numbersDR[5] || numbersDR[6] || numbersDR[7] || numbersDR[8] || numbersDR[9]
					 || numbersDR[10] || numbersDR[11]);


endmodule  