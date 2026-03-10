`timescale 1ns / 1ps

module dcmotor(
    input clk,
    input reset,
    input [7:0] current_temp,
    input [7:0] target_temp,

    output pwm_fan,
    output reg [3:0] r_duty_cycle
    );

    localparam OFF = 4'd0;
    localparam LOW_SPEED = 4'd7;
    localparam HIGH_SPEED = 4'd9;

    reg [3:0] r_counter_pwm = 0;

    // duty cycle control
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_duty_cycle <= OFF;
        end
        else begin
            if(current_temp > target_temp + 4) begin
                r_duty_cycle <= HIGH_SPEED;
            end
            else if(current_temp > target_temp) begin
                r_duty_cycle <= LOW_SPEED;
            end
            else begin
                r_duty_cycle <= OFF;
            end
        end
    end

    // 10MHz PWM gen
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter_pwm <= 0;
        end
        else begin
            if(r_counter_pwm >= HIGH_SPEED) begin // 100Mhz / 10 -> 10Mhz
                r_counter_pwm <= 0;
            end
            else begin
                r_counter_pwm <= r_counter_pwm + 1;
            end
        end
    end

    assign pwm_fan = (r_counter_pwm < r_duty_cycle); // duty 결정
endmodule
