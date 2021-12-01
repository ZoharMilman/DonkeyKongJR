
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
					input		logic	monkeyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] monkeyRGB, 
					     
		  // numbers 
					input		logic anyNumDR,
					input 	logic [11:0] numbersDR,
					input		logic [11:0] [7:0] numbersRGB,
					
					
		  // background 
					input    logic ropesDrawingRequest, // box of numbers
					input		logic	[7:0] ropesRGB,   
					input		logic	[7:0] backGroundRGB, 
			  
				   output	logic	[7:0] RGBOut
);


int i; 


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (monkeyDrawingRequest == 1'b1 )   
			RGBOut <= monkeyRGB;  //first priority 
			
			
		 
//				else if ( rec_DR == 1'b1 )
//						RGBOut <= rec_RGB;
				
				//Check for every number if it has a drawing request
				else if (anyNumDR) begin
					for (i = 0; i < 12; i = i + 1) begin
				
							if (numbersDR[i]) 
								RGBOut <= numbersRGB[i];
							
						  end
				end
				
				
				else if (ropesDrawingRequest == 1'b1)
						RGBOut <= ropesRGB;
						else 
							RGBOut <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


