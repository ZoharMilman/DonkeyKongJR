//This module is used to generate NUMBERS amount of random numbers
//-- Zohar Milman Dec 2021 

module RANDOM_SPEED_GEN (
			input logic clk,
			input logic resetN,
			input logic [8:0] [3:0] randomnumbers,
			
		
			output logic [ROPES-1:0][6:0] X_SPEED
);

parameter int ROPES = 6;
always @(posedge clk or negedge resetN) begin
	 if ( !resetN ) begin
		for (int i = 0 ; i < ROPES; i = i + 1) begin
			X_SPEED[i] = 7'b0;
		end
	 end
	 else begin
		for (int i = 1 ; i < ROPES + 1; i = i + 1) begin
			if ( (randomnumbers[0] || randomnumbers[1] || randomnumbers[2]) && !X_SPEED[i - 1]) begin
				X_SPEED[i - 1] <= (((randomnumbers[0] + randomnumbers[1] + randomnumbers[2]) * 10 * i) / (1 + 10 * i) ) * 3;
				if ((((randomnumbers[0] + randomnumbers[1] + randomnumbers[2]) * i) / (1 + i) ) < 10) begin
					X_SPEED[i - 1] <= (((randomnumbers[0] + randomnumbers[1] + randomnumbers[2]) * i) / (1 + i) ) * 10;
				end
				else X_SPEED[i - 1] <= (((randomnumbers[0] + randomnumbers[1] + randomnumbers[2]) * i) / (1 + i) ) * 5;
			end
		end
	 end
end


endmodule 
