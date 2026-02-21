`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input btn,
    input tb_mode,

    output [15:0] led
    );
    
    parameter IDLE = 3'b111;    // Power On/RESET
    parameter LIN_A = 3'b000;   // 직선형 ->
    parameter LIN_B  = 3'b001;  // 직선형 <-
    parameter SYM_A = 3'b010;   // 대칭형 <- x ->
    parameter SYM_B = 3'b011;   // 대칭형 -> x <-
    
    reg [2:0] r_mode = IDLE;
    reg r_prev_btn = 0;
    reg r_clean_btn;

    wire w_tick_50ms;
    wire w_clean_btn;
    wire [15:0] w_led;

    tick u_tick( // 50ms tick generation module
        .clk(clk),
        .reset(reset),
        .tb_mode(tb_mode),
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
                if(r_mode == SYM_B) begin // 마지막 모드 도달 시
                    r_mode <= LIN_A;      // 첫 모드로
                end else begin
                    r_mode <= r_mode + 1;
                end
            end
            r_prev_btn <= w_clean_btn;
        end
    end
    
    assign led = w_led;
endmodule
