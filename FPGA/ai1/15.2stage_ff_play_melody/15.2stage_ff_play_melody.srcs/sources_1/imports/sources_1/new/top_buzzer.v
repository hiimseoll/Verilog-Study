`timescale 1ns / 1ps

module top_buzzer(
    input clk,
    input reset,
    input btnL, btnC, btnR,     // 도, 레, 미
          btnU, btnD, btnJ3,     // 파, 솔, 라

    output  [1:0] led,
    output buzzer
    );

    wire w_btnL, w_btnC, w_btnR,     // 도, 레, 미
         w_btnU, w_btnD, w_btnJ3;    // 파, 솔, 라

    debouncer u_btnL_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnL),
        .clean_btn(w_btnL)
    );

    debouncer u_btnC_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnC),
        .clean_btn(w_btnC)
    );

    debouncer u_btnR_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnR),
        .clean_btn(w_btnR)
    );

    debouncer u_btnU_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnU),
        .clean_btn(w_btnU)
    );

    debouncer u_btnD_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnD),
        .clean_btn(w_btnD)
    );

    debouncer u_btnJ3_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnJ3),
        .clean_btn(w_btnJ3)
    );

    play_melody u_play_melody(
        .clk(clk),
        .reset(reset),
        .btnL(w_btnL),
        .btnC(w_btnC),
        .btnR(w_btnR),
        .btnU(w_btnU),
        .btnD(w_btnD),
        .btnJ3(w_btnJ3),
        .buzzer(buzzer)
    );
endmodule
