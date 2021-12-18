//This module uses a for loop to create a few numbers and set their locations to desired locations. 
//-- Zohar Milman Dec 2021 


module MULTIPLE_NUMBERS_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [NUMBERS-1:0] [3:0] numbersToShow,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			input logic startOfFrame,
			
			//Movement inputs 
			input logic [ROPES-1:0][31:0] SIGNED_SPEEDS,
			
			//Collision inputs
			input logic [NUMBERS-1:0] singleHit,
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [NUMBERS-1:0] numbersDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [NUMBERS-1:0] [7:0] numbersRGB,
			output logic [NUMBERS-1:0] showNum
			
);



int j;
int COLUMN_X, COLUMN_SPEED;

parameter int INITIAL_X = 150;
parameter int xDiff = 50;
parameter int yDiff = 100;

parameter int COLUMNS = 3;
parameter int NUMBERS = 3;
parameter int ROPES = 6;

//Creating hit flags for the disappearing numbers. 

logic [NUMBERS-1:0] [8:0] timeout; 

always_ff@(posedge clk or negedge resetN) begin

	if (!resetN) begin
	
		for (j = 0; j < NUMBERS; j = j + 1) begin
			timeout[j] <= 9'b0;
			showNum[j] <= 1'b1;
		end
		
	end
	
	else begin
			
		for (j = 0; j < NUMBERS; j = j + 1) begin
			if (singleHit[j]) timeout[j] <= 9'd450;
			else if (timeout[j] == 9'b0) showNum[j] <= 1'b1;
			else showNum[j] <= 1'b0;
		end
		if (startOfFrame) begin
			for (j = 0; j < NUMBERS; j = j + 1) begin
				if (timeout[j]) timeout[j] <= timeout[j] -1;
			end
		end
		
	end
end



genvar i;


generate
	
	//We have 3 numbers per column, so all in all NUMBERS/3 columns
		for (i = 0; i < NUMBERS; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
			//creating the numbers in each column.
			NUMBER_DISPLAY number (
											.clk(clk),
											.resetN(resetN),
											.singleHit(singleHit),
											.startOfFrame(startOfFrame),
											.pixelX(pixelX),
											.pixelY(pixelY),
											.KeyPad(numbersToShow[i]), 
											.X_SPEED(SIGNED_SPEEDS[i / 3]),
											.INITIAL_X(INITIAL_X + ((i / 3) * xDiff)),
											.INITIAL_Y(100 + ((i % 3) * yDiff)),
											.show(showNum[i]),
											.numDR(numbersDR[i]),
											.numRGB(numbersRGB[i])
										 );
		end							 
endgenerate 


endmodule  