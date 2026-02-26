`timescale 1ns / 1ps

module top_my_pwm_dcmotor(
    input clk,
    input reset,
    input increase_duty_btn,
    input decrease_duty_btn,
    input [1:0] motor_direction,

    output [1:0] in1_in2,
    output pwm_led,
    output pwm_out,
    output [7:0] seg,
    output [3:0] an
    );

    wire w_clean_inc_btn;
    wire w_clean_dec_btn;
    wire [3:0] w_duty_cycle;

    debouncer u_increase_duty_btn(
        .btn(increase_duty_btn),
        .clk(clk),
        .reset(reset),
        .clean_btn(w_clean_inc_btn)
    );

    debouncer u_decrease_duty_btn(
        .btn(decrease_duty_btn),
        .clk(clk),
        .reset(reset),
        .clean_btn(w_clean_dec_btn)
    );

    pwm_duty_control u_pwm_duty_control(
        .clk(clk),
        .reset(reset),
        .increase_duty(w_clean_inc_btn),
        .decrease_duty(w_clean_dec_btn),
        .duty_cycle(w_duty_cycle),
        .pwm_out(pwm_out),
        .pwm_led(pwm_led)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .in_data(w_duty_cycle),
        .motor_direction(motor_direction),
        .an(an),
        .seg(seg)
    );

    assign in1_in2 = motor_direction;
endmodule
