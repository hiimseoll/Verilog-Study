`timescale 1ns / 1ps

module top_my_buzzer(
    input clk,
    input reset,
    input btnL, btnR,
    
    output buzzer
    );

    wire w_btnL, w_btnR;

    debouncer u_btnL_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnL),
        .clean_btn(w_btnL)
    );

    debouncer u_btnR_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnR),
        .clean_btn(w_btnR)
    );

    play_melody u_play_melody(
        .clk(clk),
        .reset(reset),
        .btnL(w_btnL),
        .btnR(w_btnR),
        .buzzer(buzzer)
    );
endmodule
