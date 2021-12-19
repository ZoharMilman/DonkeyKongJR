//This module manages the required number and the score of the player.
//-- Eitan Meilik Dec 2021 


module SCORE_CONTROLLER (
			//System inputs 
			input logic clk,
			input logic resetN,
			input logic [NUMBERS-1:0] SingleHitPulse,
			input logic [1:0] operandHit,
			input logic [NUMBERS-1:0] [3:0] NumbersToShow,
			input logic startOfFrame,
			
			
			output logic [5:0] [3:0] ScoreToShow,
			output logic SignToShow,
			output logic ShowSign,
			output logic trigger
			
);
parameter int NUMBERS = 9;
int score;
int goal;
int positive_score;
int change;
logic startmarker;
logic [10:0] timeout;
logic init_change;

// random goal generator
random #(.SIZE_BITS(8), 
			.MIN_VAL(1), 
			.MAX_VAL(150)
			) random_gen (.clk(clk), 
							  .resetN(resetN),
							  .rise(operandHit[0] | operandHit[1] | init_change),
							  .dout(goal));

// state machine decleration 
	enum logic [2:0] {Sidle, Splus, Sminus } pres_st, next_st;

//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN) begin
	   
   if ( !resetN ) begin  // Asynchronic reset
		ScoreToShow[0] <= 9;
		ScoreToShow[1] <= 9;
		ScoreToShow[2] <= 9;
		timeout <= 11'd1801;
		pres_st <= Sidle;
		score <= 0;
		startmarker <= 1'b0;
		init_change <= 1'b0;
		trigger <= 1'b0;
   end
	else begin 		// Synchronic logic FSM
		if (startOfFrame && timeout < 11'd1801) timeout <= timeout - 1;
		if ( operandHit || startmarker) startmarker <= 1'b1;
		if (!timeout || (startmarker && ScoreToShow[2] == 9) ) begin
			ScoreToShow[2] <= (goal % 10);
			ScoreToShow[1] <= (goal / 10) % 10;
			ScoreToShow[0] <= goal / 100;
			init_change <= 1'b0;
			trigger <= 1'b1;
			timeout <= 11'd1800;
		end
		if (!(timeout - 1) && ScoreToShow[2] == (goal % 10) && ScoreToShow[1] == (goal / 10) % 10 && ScoreToShow[0] == goal / 100 ) begin
			init_change <= 1'b1;
		end
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
assign ScoreToShow [5] = (positive_score % 10);
assign ScoreToShow [4] = ((positive_score / 10) % 10);
assign ScoreToShow [3] = (positive_score / 100);
endmodule  