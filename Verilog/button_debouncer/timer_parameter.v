`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 05/15/2025 11:47:48 AM
// Credit: Anas Salah Eddin (https://www.youtube.com/watch?v=2dgFvj3WwXk&t=1463s)
// Modified/Edited by: M. Cherciu
// Module Name: timer parameter
// Version: 1.0
// Description: a modul to take care of the bouncing/debouncing button
// Dependencies:
// Revision:
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module timer_parameter
	#(parameter FINAL_VALUE = 255)(
	input clk,
	input reset_n,
	input enable,
	output done
	);

    localparam BITS = $clog2(FINAL_VALUE);
	reg [BITS - 1:0] Q_reg;

	assign done = (Q_reg == FINAL_VALUE);

	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n) 
		begin
			Q_reg <= {BITS{1'b0}};
		end 
		else if (enable) 
		begin
			if (done) begin
				Q_reg <= {BITS{1'b0}};
			end else begin
				Q_reg <= Q_reg + {{(BITS-1){1'b0}}, 1'b1};
			end
		end
	end

endmodule