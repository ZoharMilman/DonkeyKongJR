
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,   // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Monkey,
			input	logic	drawing_request_Brackets,
			input logic [NUMBERS-1:0] drawing_request_Numbers,
			input logic drawing_request_Rope, 
			
			
			
			output logic ropeCollision,  // active in case of collision between the monkey and a rope
			output logic collision, 	 // active in case of collision between two objects
			output logic [NUMBERS-1:0] SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic num_hit
);

// drawing_request_Monkey   		-->  monkey
// drawing_request_Brackets      -->  brackets
// drawing_request_Numbers       -->  number
// drawing_request_Rope      		-->  rope


parameter int NUMBERS = 3; 

int i;

assign collision = ( (drawing_request_Monkey &&  drawing_request_Brackets) || (drawing_request_Monkey &&  drawing_request_Numbers) 
						|| (drawing_request_Monkey &&  drawing_request_Rope));// any collision 
						 						
assign ropeCollision = (drawing_request_Monkey && drawing_request_Rope);
assign num_hit = (drawing_request_Monkey && drawing_request_Numbers);

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		for (i = 0; i < NUMBERS; i = i + 1) begin 
			SingleHitPulse[i] <= 1'b0; 
		end
		
	end 
	else begin 
			for (i = 0; i < NUMBERS; i = i + 1) begin 
				SingleHitPulse[i] <= 1'b0; 
			end

			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
						
//Handling hitting a number

			for (i = 0; i < NUMBERS; i = i + 1) begin 
				if ( collision  && (flag == 1'b0) && drawing_request_Numbers[i]) begin 
					flag	<= 1'b1; // to enter only once 
					SingleHitPulse[i] <= 1'b1 ; 
				end 
			end
	end 
end

endmodule
