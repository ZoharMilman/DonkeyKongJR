// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	monkey_moveCollision	(	
					
					//System Inputs
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					
					
					//Inputs from keyboard 
					input logic leftPressed, 
					input logic rightPressed, 
					input logic downPressed, 
					input logic upPressed, 
					
					//Collision related inputs
					input logic collision,
					input logic onRope,
					input logic [ROPES-1:0] ropeCollisions,
					input logic [ROPES-1:0] [1:0] electroStatus,
					input logic onBlock, 
					input logic objectHit,  
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					
					//Movement inputs
					input int addedSpeed,
					
					output    logic GameOverN,
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


parameter ROPES = 6;


parameter int E_TIME = 5;

//topLeftY == 388 || topLeftY == 259 || topLeftY == 131

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int MAX_Y_SPEED = 230;

int Y_ACCEL;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;




/////--------------------------------------------------------------------------------------------------------------------
//	Handling electrified ropes. 
logic [6:0] timer;
int i;
logic electrified;

//If the monkey is on an electrified rope, it cant move for E_TIME seconds. 
always_ff@(posedge clk or negedge resetN) begin
	if (!resetN) begin
		timer <= E_TIME * 30;
		electrified <= 1'b0;
	end
	
	//Check if the monkey got electrified
	else begin 
		for (i = 0; i < ROPES; i = i + 1) begin
			if ((ropeCollisions[i] && electroStatus[i] == 2'b10)) begin 
				electrified <= 1'b1; 
			end
		end
		
		
		if (electrified == 1'b1) begin 
			//Countdown
			if (startOfFrame) begin 
				if (timer) timer <= timer - 1;
				//Once countdown reaches zero, we return electrified to 0 and reset the timer
				else begin
					timer <= E_TIME * 50;
					electrified <= 1'b0; 
				end
			end
		end
	end

end


logic footing;
assign footing = ((onRope && !electrified) | (onBlock && ( (383 < topLeftY && topLeftY < 391) || (255 < topLeftY && topLeftY < 263) ))); 


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		Y_ACCEL <= 0;
	end 
	else begin
		
		//Default accelarion is 0
		Y_ACCEL <= 0;
		if (!footing) begin
			Y_ACCEL <= -10; 
		end
		

		if  (footing) begin 
			Yspeed <= 0;
			if (!electrified) begin 
						
				if (upPressed) begin 
					//Rope Climbing
					if (onRope) Yspeed <= -100;
					//Jump
					else Yspeed <= -300;
					
				end
				
				if  (downPressed && onRope) begin 
					//Rope Climbing 
					Yspeed <= 100;
				end
			
			end
		end

		// perform  position and speed integral only 30 times per second 
		if ((263 < topLeftY && topLeftY < 323) &&  topLeftX < 384 && topLeftX > 224 && Yspeed < 0) Yspeed <= 0;
		if (startOfFrame == 1'b1) begin 
//				if (onBlock && HitEdgeCode [2] == 1 && Yspeed > 0) Yspeed <= 0;
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				
				if (Yspeed < MAX_Y_SPEED ) //  limit the spped while going down 
						Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 					


		end
	end
end 



  
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
//		hitright <= 1'b0;
//		hitleft <= 1'b0;
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	
	else if (!electrified) begin

		//Default value of Xspeed is the current ropes speed
		
		if ((262 < topLeftY && topLeftY < 323) && (topLeftX < 387 && topLeftX > 381 && addedSpeed < 0)) Xspeed<= INITIAL_X_SPEED;
		else if ((262 < topLeftY && topLeftY < 323) && (topLeftX > 221 && topLeftX < 227 && addedSpeed > 0)) Xspeed<= INITIAL_X_SPEED;
		else Xspeed<= INITIAL_X_SPEED + addedSpeed;
		
		if (rightPressed && topLeftX < 603 && !((262 < topLeftY && topLeftY < 323) && topLeftX > 221 && topLeftX < 227)) begin 
			//Handling edge of screen limitations, left side
//			if (collision && HitEdgeCode [1] == 1 && Xspeed > 0) Xspeed <= -Xspeed;
			Xspeed <= 150;
		end        
			
		if (leftPressed && topLeftX > 5 && !((262 < topLeftY && topLeftY < 323) && topLeftX < 387 && topLeftX > 381)) begin 
			//Handling edge of screen limitations, right side
//			if (collision && HitEdgeCode [3] == 1 && Xspeed < 0) Xspeed <= -Xspeed;
			Xspeed <= -150;
		end
//		if (topLeftX == 570 || topLeftX == 4) begin
//			if (Xspeed > 0 && topLeftX == 570) begin
//				Xspeed <= 0;
//				hitright<=1'b1;
//			end
//			if (Xspeed < 0 && topLeftX == 4) begin
//				Xspeed <= 0;
//				hitleft <= 1'b1;
//			end
//		end
		//Updating the X  value using Xspeed
		if (startOfFrame == 1'b1) begin
//			if (onBlock && HitEdgeCode [1] == 1 && Xspeed > 0) Xspeed <= 0;
//			if (onBlock && HitEdgeCode [3] == 1 && Xspeed < 0) Xspeed <= 0;
//			hitright <= 1'b0;
//			hitleft <= 1'b0;
			if(390 < topLeftY && topLeftY < 423) Xspeed <= 0;
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end

	end		
					
			
//////------------------------------------------------------------------------------------------------------------
	
	
	

end
//
////get a better (64 times) resolution using integer

   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER;    
assign   GameOverN = (topLeftY > 475) ? 1'b0: 1'b1;

endmodule