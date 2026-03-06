`timescale 1ns / 1ps

module fsm_pattern(
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg out
    );

    // 상태 정의
    parameter start = 8'hAA; // temporary val
    parameter l = 8'h6C;
    parameter e = 8'h65;
    parameter d = 8'h64;
    parameter zero = 8'h30;
    parameter o = 8'h6F;
    parameter n = 8'h6E;
    parameter f = 8'h66;
    parameter ff = 8'hFF; // temporary val
    parameter cr = 8'h0D;
    parameter lf = 8'h0A;
    parameter on_lf_wait = 8'hCC;  // temporary val 
    parameter off_lf_wait = 8'hDD; // temporary val

    parameter LED_ON = 8'h11; // temporary val
    parameter LED_OFF = 8'h00; // temporary val

    reg [7:0] current_state = start;
    reg [7:0] next_state = start;

    // next state logic
    always @(*) begin
        case (current_state)
            start : next_state = (in == l) ? l : start;
            l     : next_state = (in == e) ? e : (in == l) ? l : start;
            e     : next_state = (in == d) ? d : (in == e) ? e : start;
            d     : next_state = (in == zero) ? zero : (in == d) ? d : start;
            zero  : next_state = (in == o) ? o : (in == zero) ? zero : start;
            o     : next_state = (in == n) ? n : (in == f) ? f : (in == o) ? o : start;
            f     : next_state = (in == f) ? ff : start;
            n     : next_state = (in == cr) ? on_lf_wait : (in == n) ? n : start;
            ff    : next_state = (in == cr) ? off_lf_wait : (in == ff) ? ff : start;
            on_lf_wait: next_state = (in == lf) ? LED_ON : (in == n) ? on_lf_wait :  start;
            off_lf_wait: next_state = (in == lf) ? LED_OFF : (in == f) ? off_lf_wait : start;
            LED_ON:  next_state = (in == l) ? l : LED_ON;  
            LED_OFF: next_state = (in == l) ? l : LED_OFF; 
            default : next_state = start;
        endcase
    end

    // current state register
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            current_state <= start;
        end
        else begin
            current_state <= next_state;
        end
    end

    // output logic
    always @(*) begin
        if(current_state == LED_ON) begin
            out = 1'b1;
        end
        else if(current_state == LED_OFF) begin
            out = 1'b0;
        end
        else begin
            out = 1'b0; // default state
        end
    end
endmodule
