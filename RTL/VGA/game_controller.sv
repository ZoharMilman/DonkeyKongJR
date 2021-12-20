
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
			input logic [ROPES-1:0] drawing_request_Rope, 
			input logic [1:0] drawing_request_Operands,
			input logic drawing_request_Block, 
			input logic drawing_request_Water,
			
			input logic [ROPES-1:0][31:0] ROPE_SPEEDS,
			
			
			//Rope outputs
			output logic anyRopeCollision,  // active in case of collision between the monkey and a rope
			output logic [ROPES-1:0] ropeCollision,
			output logic [31:0] CURRENT_ROPE_SPEED, // equal to the speed of the rope the monkey is on
			
			
			//General object collisions
			output logic blockCollision, 
			output logic waterCollision,
			output logic collision, 	 // active in case of collision between two objects
			output logic [ROPES-1:0] ropeDirectionToggle, //active if the rope hits anything other then the monkey
			
			
			output logic [NUMBERS-1:0] SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic objectHit,
			output logic [1:0] operandHit
			
		
);

// drawing_request_Monkey   		-->  monkey
// drawing_request_Brackets      -->  brackets
// drawing_request_Numbers       -->  number
// drawing_request_Rope      		-->  rope


parameter int NUMBERS = 3; 
parameter int ROPES = 6; 

int i;

//Monkey collisions
assign collision = ( (drawing_request_Monkey &&  drawing_request_Brackets) || (drawing_request_Monkey &&  drawing_request_Numbers) 
						|| (drawing_request_Monkey &&  drawing_request_Rope) || (drawing_request_Monkey && drawing_request_Operands));// any collision 
						 						
assign anyRopeCollision = (drawing_request_Monkey && drawing_request_Rope);
assign blockCollision = (drawing_request_Monkey && drawing_request_Block);
assign waterCollision = (drawing_request_Monkey && drawing_request_Water);
assign objectHit = ((drawing_request_Monkey && drawing_request_Numbers) || (drawing_request_Monkey && drawing_request_Operands));

assign onlyBGandMonkey = (drawing_request_Monkey && !collision);


//Rope collisions
always_comb begin
	//Toggling collisions
	for (i = 0; i < ROPES; i = i + 1) begin
		ropeDirectionToggle[i] = ((drawing_request_Rope[i] && drawing_request_Block) || (drawing_request_Rope[i] && drawing_request_Brackets));
	end
	//Monkey collisions and getting current rope speed
	for (i = 0; i < ROPES; i = i + 1) begin
		ropeCollision[i] = (drawing_request_Rope[i] && drawing_request_Monkey);	
	end
end







logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions
 

 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		operandHit <= 2'b00;
		for (i = 0; i < NUMBERS; i = i + 1) begin 
			SingleHitPulse[i] <= 1'b0; 
		end
		
	end 
	else begin 
			operandHit <= 2'b00;
			
			for (i = 0; i < NUMBERS; i = i + 1) begin 
				SingleHitPulse[i] <= 1'b0; 
			end

			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
						

			if ( collision  && (flag == 1'b0) && drawing_request_Operands[0]) begin 
				flag	<= 1'b1; // to enter only once 
				operandHit[0] <= 1'b1 ;
			end
			if ( collision  && (flag == 1'b0) && drawing_request_Operands[1]) begin 
				flag	<= 1'b1; // to enter only once 
				operandHit[1] <= 1'b1 ;
			end
			//Handle number collision
			for (i = 0; i < NUMBERS; i = i + 1) begin 
				if ( collision  && (flag == 1'b0) && drawing_request_Numbers[i]) begin 
					flag	<= 1'b1; // to enter only once 
					SingleHitPulse[i] <= 1'b1 ; 
				end 
			end
			
			
			//Handle rope collision
			for (i = 0; i < ROPES; i = i + 1) begin
				if (ropeCollision[i]) CURRENT_ROPE_SPEED <= ROPE_SPEEDS[i];
//				else CURRENT_ROPE_SPEED <= 0;
			end
			
			if (onlyBGandMonkey) CURRENT_ROPE_SPEED <= 0;
	end 
end

endmodule
