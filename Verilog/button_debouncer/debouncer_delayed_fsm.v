`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Credit: Anas Salah Eddin (https://www.youtube.com/watch?v=2dgFvj3WwXk&t=1463s)
// Create Date: 05/15/2025 11:47:48 AM
// Modified/Edited:M. Cherciu
// Module Name: gpio_serialization
// Version: 1.0
// Description: a modul to take care of the bouncing/debouncing button
// Dependencies:
// Revision:
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module debouncer_delayed_fsm(
    input clk,
    input reset_n,
    input noisy,
    input timer_done,
    output timer_reset,
    output debounced
    );
    
    reg [1:0] state_reg, state_next;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
    
    //Sequential state register
    always @( posedge clk, negedge reset_n)
    begin
        if (~reset_n)
           state_reg <= 0;
        else
            state_reg <= state_next; 
    end
    
    //Next state logic
    always @(*)
    begin
        state_next = state_reg;
        case (state_reg)
            s0: if(~noisy)
                    state_next = s0;
                 else if(noisy)
                    state_next = s1;
            s1: if(~noisy)
                    state_next = s0;
                 else if (noisy & ~timer_done)
                    state_next = s1;
                 else if (noisy & timer_done)
                    state_next = s2;
             s2: if (~noisy)
                    state_next = s3;
                 else if (noisy)
                    state_next = s2;
             s3: if (noisy)
                    state_next = s2;
                 else if (~noisy & ~timer_done)
                    state_next= s3;
                 else if (~noisy & timer_done)
                    state_next = s0;
             default: state_next = s0;
         endcase
    end
    
    assign timer_reset = (state_reg == s0) | (state_reg == s2);
    assign debounced = (state_reg == s2) | (state_reg == s3);
    
endmodule
