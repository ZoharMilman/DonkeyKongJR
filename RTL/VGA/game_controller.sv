
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,   // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Monkey,
			input	logic	drawing_request_1,
			input logic drawing_request_2,
			input logic drawing_request_3, 
			
			output logic ropeCollision,  // active in case of collision between the monkey and a rope
			output logic collision, 	 // active in case of collision between two objects
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic num_hit
);

// drawing_request_Ball   -->  monkey
// drawing_request_1      -->  brackets
// drawing_request_2      -->  number
// drawing_request_3      -->  rope


assign collision = ( (drawing_request_Monkey &&  drawing_request_1) || (drawing_request_Monkey &&  drawing_request_2) 
						|| (drawing_request_Monkey &&  drawing_request_3));// any collision 
						 						
assign ropeCollision = (drawing_request_Monkey && drawing_request_3);
assign num_hit = (drawing_request_Monkey && drawing_request_2);

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 
			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
						
//Handling hitting a number
if ( collision  && (flag == 1'b0) && drawing_request_2) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b1 ; 
		end ; 
	end 
end

endmodule
