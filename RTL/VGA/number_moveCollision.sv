



module number_moveCollision (
		//System inputs 
		input logic clk, 
		input logic resetN,
		input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
		
		
		//Movement inputs
		input int X_SPEED,
		input int INITIAL_X,
		input int INITIAL_Y,
		
		output logic signed [10:0] topLeftX,
		output logic signed [10:0] topLeftY

) ;

const int	FIXED_POINT_MULTIPLIER	=	64;

//parameter int X_SPEED = 30;
//parameter int INITIAL_X = 280;
parameter int Y_SPEED = 100;			//since the numbers are moving at a constant speed on the y axis. 
parameter int upperYlimit = 640; 
parameter int lowerYlimit = 0; 

logic flag;

int Xspeed, topLeftX_FixedPoint, Yspeed, topLeftY_FixedPoint; // local parameters 
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or collision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	
	else begin 
		
		if (startOfFrame == 1'b1) begin
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + X_SPEED;
		end
	end
end

///////-----------------------------------------------------------------------------------------------------------------
// y axis movement calculation

//always_ff@(posedge clk or negedge resetN)
//begin
//	if(!resetN)
//	begin
//		flag <= 1'b0;
//		Yspeed <= Y_SPEED;
//		topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
//	end
//	
//	else begin 
//		
//		if ((topLeftY < upperYlimit || topLeftY > lowerYlimit) && !flag) begin
//			Yspeed <= -Yspeed;
//			flag <= 1'b1;
//		end
//		
//		if (startOfFrame == 1'b1) begin
//			flag <= 1'b0;
//			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Y_SPEED;
//		end
//	end
//end



assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;
assign   topLeftY = INITIAL_Y;//topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER;
endmodule 


