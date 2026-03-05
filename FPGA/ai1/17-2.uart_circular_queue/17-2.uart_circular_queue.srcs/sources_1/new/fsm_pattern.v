`timescale 1ns / 1ps

module fsm_pattern(
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg out
    );

    // 상태 정의
    parameter start = 8'hAA; // 임시 val
    parameter l = 8'h6C;
    parameter e = 8'h65;
    parameter d = 8'h64;
    parameter zero = 8'h30;
    parameter o = 8'h6F;
    parameter n = 8'h6E;
    parameter f = 8'h66;
    parameter ff = 8'hFF; // 임시 val
    parameter cr = 8'h0D;
    parameter lf = 8'h0A;

    parameter LED_ON = 8'h11; // 임시 val
    parameter LED_OFF = 8'h00; // 임시 val

    reg [7:0] current_state = start;
    reg [7:0] next_state;

    // next state logic
    always @(*) begin
        next_state = start;

        case (current_state)
            start : next_state = (in == l) ? l : start;
            l     : next_state = (in == e) ? e : (in == l) ? l : start;
            e     : next_state = (in == d) ? d : (in == e) ? e : start;
            d     : next_state = (in == zero) ? zero : (in == d) ? d : start;
            zero  : next_state = (in == o) ? o : (in == zero) ? zero : start;
            o     : next_state = (in == n) ? n : (in == f) ? f : (in == o) ? o : start;
            f     : next_state = (in == f) ? ff : start;
            n:    next_state = (in == cr) ? LED_ON : (in == n) ? n : start;
            ff:   next_state = (in == cr) ? LED_OFF : (in == ff) ? ff : start;
            LED_ON:  next_state = (in == lf) ? start : LED_ON;  // LF 오면 초기 상태
            LED_OFF: next_state = (in == lf) ? start : LED_OFF; // LF 오면 초기 상태

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
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            out <= 1'b0;
        end
        else if(current_state == LED_ON) begin
            out <= 1'b1;
        end
        else if(current_state == LED_OFF) begin
            out <= 1'b0;
        end
    end
endmodule
