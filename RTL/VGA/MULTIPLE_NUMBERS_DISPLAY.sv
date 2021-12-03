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
			input logic [NUMBERS-1:0] singleHit,
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [NUMBERS-1:0] numbersDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [NUMBERS-1:0] [7:0] numbersRGB
			
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



//"Random" number support. 
//We have set positions and set numbers, we want to randomize each number's position in the fixed positions. 


parameter logic [NUMBERS-1:0][3:0] possible_numbers = {4'b0000, 4'b1000, 4'b0000};

//Helper variables


logic [NUMBERS-1:0][3:0] numbers_randomized; 
logic rise; 
logic [3:0] dout;

random #(.SIZE_BITS(4), 
			.MIN_VAL(0), 
			.MAX_VAL(NUMBERS-1)
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(rise),
							  .dout(dout)); 
			
always_ff@(posedge clk or negedge resetN) begin
	if (!resetN) begin 
		for (j = 0; j < NUMBERS; j = j + 1) begin
		//Rise rise to get a new random number
			rise <= 1'b1; 
			numbers_randomized[j] <= possible_numbers[dout]; 
			rise <= 1'b0;
		end
	end
	
end


//Creating hit flags for the disappearing numbers. 

logic [NUMBERS-1:0] showNum; 

always_ff@(posedge clk or negedge resetN) begin

	if (!resetN) begin
	
		for (j = 0; j < NUMBERS; j = j + 1) begin
			showNum[j] <= 1'b1;
		end
		
	end
	
	else begin
			
		for (j = 0; j < NUMBERS; j = j + 1) begin
			if (singleHit[j]) showNum[j] <= 1'b0;
			else if (showNum[j]) showNum[j] <= 1'b1;
		end
		
	end
end



genvar i;

generate

	for (i = 0; i < NUMBERS; i = i + 1) begin : NUMBER_DISPLAY_GENERATION
		
		NUMBER_DISPLAY number (
										.clk(clk),
										.resetN(resetN),
										.singleHit(singleHit),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.KeyPad(numbers_randomized[i]), 
										.topLeftX(topLeftX + (xDiff * (i / collums))), //TODO for some reason verilog refuses to treat my boy NUM_AMOUNT_Y as an int so i inputed this as a hard coded number. 
										.topLeftY(topLeftY + (yDiff * (i % collums))),
										.show(showNum[i]),
										.numDR(numbersDR[i]),
										.numRGB(numbersRGB[i])
									 );
									 
	end
endgenerate 


endmodule  