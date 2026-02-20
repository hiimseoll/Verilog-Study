`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input btn,

    output [15:0] led
    );
    
    
    reg [2:0] r_mode = 3'b111;
    reg r_prev_btn = 0;
    reg r_clean_btn;

    wire w_tick_50ms;
    wire w_clean_btn;
    wire [15:0] w_led;

    parameter LINEAR_FORWARD = 3'b000;
    parameter LINEAR_BACKWARD  = 3'b001;
    parameter SYMMETRICAL_FORWARD = 3'b010; 
    parameter SYMMETRICAL_BACKWARD = 3'b011;

    tick u_tick( // 50ms tick generation module
        .clk(clk),
        .reset(reset),
        .tick_50ms(w_tick_50ms)
    );

    debouncer u_debouncer(
        .reset(reset),
        .btn(btn),
        .tick(w_tick_50ms),
        .clean_btn(w_clean_btn)
    );

    led_control u_led_control(
        .tick(w_tick_50ms),
        .reset(reset),
        .mode(r_mode),
        .led(w_led)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_mode <= 3'b111;
            r_prev_btn <= 0;
        end else begin

            if(w_clean_btn && !r_prev_btn) begin   // r_mode 순환
                if(r_mode == SYMMETRICAL_BACKWARD) begin
                    r_mode <= LINEAR_FORWARD;
                end else begin
                    r_mode <= r_mode + 1;
                end
            end
            r_prev_btn <= w_clean_btn;
        end
    end
    
    assign led = w_led;
endmodule
