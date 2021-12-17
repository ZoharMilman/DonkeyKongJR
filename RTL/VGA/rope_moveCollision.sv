



module rope_moveCollision (
		//System inputs 
		input logic clk, 
		input logic resetN,
		input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
		
		//Collisions inputs 
		
		output logic signed [10:0] topLeftX,
		output logic signed [10:0] topLeftY

) ;

const int	FIXED_POINT_MULTIPLIER	=	64;

parameter int X_SPEED = 30;
parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 100;
int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or collision


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	
	else begin 
			if (startOfFrame == 1'b1) begin
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end
	end
end

assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;
assign   topLeftY = INITIAL_Y;
endmodule 