//This module manages the required number and the score of the player.
//-- Eitan Meilik Dec 2021 


module SCORE_CONTROLLER (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [NUMBERS-1:0] SingleHitPulse,
			input logic [1:0] operandHit,
			input logic [NUMBERS-1:0] [3:0] NumbersToShow,
			
			
			output logic [2:0] [3:0] ScoreToShow,
			output logic SignToShow,
			output logic ShowSign
			
);
parameter int NUMBERS = 9;
int score;
int positive_score;
int change;

// state machine decleration 
	enum logic [2:0] {Sidle, Splus, Sminus } pres_st, next_st;

//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN) begin
	   
   if ( !resetN ) begin  // Asynchronic reset
		pres_st <= Sidle;
		score <= 0;
   end
	else begin 		// Synchronic logic FSM
		pres_st <= next_st;
		score <= score + change;
	end
end // always sync
	
always_comb // Update next state
	begin
	// set all default values 
		next_st = pres_st;
		change = 0;
		case (pres_st)
				
			Sidle: begin
				if (operandHit[0] == 1'b1) 
					next_st = Splus;
				else if (operandHit[1] == 1'b1)
					next_st = Sminus;
				end // idle
						
			Splus: begin
				for (int i = 0; i < NUMBERS; i = i + 1) begin 
					if(SingleHitPulse[i] == 1'b1)
						change = NumbersToShow [i];
				end
				if (operandHit[1] == 1'b1) 
					next_st = Sminus; 
			end // plus
						
			Sminus: begin
				for (int i = 0; i < NUMBERS; i = i + 1) begin 
					if(SingleHitPulse[i] == 1'b1)
						change = - NumbersToShow [i];
				end
				if (operandHit[0] == 1'b1)
					next_st = Splus;
			end // minus
						
						
		endcase
	end // always comb
//updating outputs
assign positive_score = (score < 0) ? -score: score;
assign SignToShow = (score < 0) ? 1'b1: 1'b0;
assign ShowSign = (score != 0) ? 1'b1: 1'b0;
assign ScoreToShow [2] = (positive_score % 10);
assign ScoreToShow [1] = ((positive_score / 10) % 10);
assign ScoreToShow [0] = (positive_score / 100);
	
endmodule  