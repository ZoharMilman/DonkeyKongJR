module MULTIPLE_OPERAND_DISPLAY (
			//System inputs 
			input logic clk,
			input logic resetN,
			
			//VGA inputs
			input logic [10:0] pixelX,
			input logic [10:0] pixelY,
			input logic startOfFrame,
			
			//Collision inputs
			input logic [1:0] singleHit,
			
		
			
			//We have a drawing request and rgbout for each of the 12 numbers
			output logic [1:0] operandDR, //output that the pixel should be dispalyed 
//			output logic anyNumDR,					//An output to be set to 1 when there is a number drawing request
			output logic [1:0][7:0] operandRGB
			
);


parameter int plusX = 50; 
parameter int plusY = 430; 

parameter int minusX = 250; 
parameter int minusY = 430; 
int j;
logic [1:0] showOperand;
logic [1:0][8:0] timeout; 

always_ff@(posedge clk or negedge resetN) begin

	if (!resetN) begin
		timeout <= 18'b0;
		for (j = 0; j < 2; j = j + 1) begin
			showOperand[j] <= 1'b1;
		end
		
	end
	
	else begin
			
		for (j = 0; j < 2; j = j + 1) begin
			if (singleHit[j]) timeout[j] <= 9'd450;
			else if (timeout[j] == 9'b0) showOperand[j] <= 1'b1;
			else showOperand[j] <= 1'b0;
		end
		
		if (startOfFrame) begin
			if (timeout[0]) timeout[0] <= timeout[0] -1;
			if (timeout[1]) timeout[1] <= timeout[1] -1;
		end	
	end
end





OPERAND_DISPLAY plus_display (.clk(clk),
										.resetN(resetN),
										.operandSel(0),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.topLeftX(plusX),
										.topLeftY(plusY),
										.show(showOperand[0]),
										.operandDR(operandDR[0]),
										.operandRGB(operandRGB[0]));
										

OPERAND_DISPLAY minus_display(.clk(clk),
										.resetN(resetN),
										.operandSel(1),
										.pixelX(pixelX),
										.pixelY(pixelY),
										.topLeftX(minusX),
										.topLeftY(minusY),
										.show(showOperand[1]),
										.operandDR(operandDR[1]),
										.operandRGB(operandRGB[1]));	

	
endmodule
							