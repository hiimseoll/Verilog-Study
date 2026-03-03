`timescale 1ns / 1ps

module top_rotary(
    input clk,
    input reset,    // sw15
    input s1, s2, key,


    output [15:0] led
    );

    wire w_clean_s1, w_clean_s2, w_clean_key;

    debouncer #(.DEBOUNCE_LIMIT(200)) u_s1_debouncer( // default: 200_000
        .clk(clk),
        .reset(reset),
        .btn(s1),
        .clean_btn(w_clean_s1)
    );

    debouncer #(.DEBOUNCE_LIMIT(200)) u_s2_debouncer( // default: 200_000
        .clk(clk),
        .reset(reset),
        .btn(s2),
        .clean_btn(w_clean_s2)
    );

    debouncer #(.DEBOUNCE_LIMIT(200)) u_key_debouncer( // default: 1_000_000
        .clk(clk),
        .reset(reset),
        .btn(key),
        .clean_btn(w_clean_key)
    );

    rotary u_rotary(
    .clk(clk),
    .reset(reset),
    .clean_s1(w_clean_s1), 
    .clean_s2(w_clean_s2), 
    .clean_key(w_clean_key),
    .led(led)
    );
endmodule
