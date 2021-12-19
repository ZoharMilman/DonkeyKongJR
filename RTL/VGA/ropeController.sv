
//This module uses a timer and changes the ropes electro status accordingly.


module ropeController (

		 //System
		 input logic clk,
		 input logic resetN,
		 
		 //VGA
		 input logic startOfFrame,
		 
		 output logic [ROPES-1:0][1:0] electroStatus

);

parameter int ROPES = 6;

parameter int HE_TIME = 5;
parameter int E_TIME = 5; 
parameter int IDLE_TIME = 10; 

logic [9:0] timer;

int counter = 0;
int i;
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		//Notice that the maximum that timer can be is 2^11-1;
		timer <= HE_TIME * 30 + E_TIME *30 + IDLE_TIME * 30; //Because startOfFrame has a frequancy of 30hz, and times are given in seconds. 
		for (i = 0; i < ROPES; i = i + 1) electroStatus[i] <= 2'b00; 
	end
	
	
	else begin
		if (startOfFrame) begin
			
			if (timer) timer <= timer - 1; //Counting down given that timer is not already 0. 
			else begin 
				timer <= 10'd600; //Reseting the timer
				electroStatus[i] = 2'b00;
				if (counter == 6) counter <= 0;
				else counter <= counter + 1;
			end	
		end
		
		//When we get to 10 seconds
		if (timer == 300)  electroStatus[counter] <= 2'b01;
		//When we get to 15 seconds
		if (timer == 150)  electroStatus[counter] <= 2'b10;
		
	end
	
	
end

endmodule