
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // monkey 
					input		logic	monkeyDrawingRequest, 
					input		logic	[7:0] monkeyRGB, 
					     
		  // numbers
					input 	logic [NUMBERS-1:0] numbersDR,
					input		logic [NUMBERS-1:0] [7:0] numbersRGB,
					
		  // operand
					input    logic [1:0] operandDR,
					input    logic [1:0] [7:0] operandRGB,
					
		  // scoreboard
					input    logic [2:0] scoreboardDR,
					input    logic [2:0] [7:0] scoreboardRGB,
					
		  // grass blocks 
					input    logic blocksDR,
					input    logic [7:0] blocksRGB,
					
		  // ropes
					input    logic ropesDrawingRequest, 
					input		logic	[7:0] ropesRGB,  
					
		  // background 
					input		logic	[7:0] backGroundRGB, 
			
			
				   output	logic	[7:0] RGBOut
);



parameter int NUMBERS = 3; 

int i; 


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (monkeyDrawingRequest == 1'b1 )   
			RGBOut <= monkeyRGB;  //first priority 
				
				//Scoreboard drawing
				else if (scoreboardDR) begin
					for (i = 0; i < 3; i = i + 1) begin
				
							if (scoreboardDR[i]) 
								RGBOut <= scoreboardRGB[i];
							
						  end
				end
				

				//Check for every number if it has a drawing request
				else if (numbersDR) begin
					for (i = 0; i < NUMBERS; i = i + 1) begin
				
							if (numbersDR[i]) 
								RGBOut <= numbersRGB[i];
							
						  end
				end
				
				//Operand drawing
				else if (operandDR) begin
						if (operandDR[0]) 	RGBOut <= operandRGB[0];
						else if (operandDR[1]) RGBOut <= operandRGB[1];
				end
				
				//Rope drawing
				else if (ropesDrawingRequest == 1'b1)
						RGBOut <= ropesRGB;
				
				//Grass blocks drawing
				else if (blocksDR) 
						RGBOut <= blocksRGB;
						else
							RGBOut <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


