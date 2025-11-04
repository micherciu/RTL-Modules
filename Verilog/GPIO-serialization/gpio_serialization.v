`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 05/15/2025 11:47:48 AM
// Authors: M.I Cherciu
// Module Name: gpio_serialization
// Version: 1.0
// Description: a module to rerialize the data of 1 byte
// Dependencies:
// Revision:
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module gpio_serialization(
    input clk,
    input [7:0] data,
    input flagon,
    output flagoff,
    output reg gs
    );

integer cnt = 8;
reg [7:0] buf_data;
reg gs_flag = 0;

always@(posedge clk)
begin
    if ( flagon )
        begin
            if( cnt == 8)
            begin
                buf_data = data;
                cnt = cnt - 1;
            end
            else if ( cnt > 1 && cnt < 8)
            begin
                cnt = cnt - 1;
                gs = buf_data[cnt];
            end
            else if (cnt == 1)
            begin
                gs = 0;
                gs_flag = 1;
                cnt = 8;
                buf_data = 0;
            end
         end
     else if ( ~flagon ) 
     begin  
        gs_flag = 0;
     end
 end
 assign flagoff = gs_flag;
endmodule
