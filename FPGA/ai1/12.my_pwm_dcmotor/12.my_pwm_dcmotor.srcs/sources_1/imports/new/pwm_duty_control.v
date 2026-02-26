`timescale 1ns / 1ps

// 100Mhz / 10 --> 10Mhz
// 10 steps(0~9)
module pwm_duty_control(
    input clk,
    input reset,
    input increase_duty,
    input decrease_duty,

    output [3:0] duty_cycle, // fnd 출력용 0~9
    output pwm_out,
    output pwm_led
    );

    reg [3:0] r_duty_cycle = 4'd5; // 50% duty
    reg [3:0] r_counter_pwm = 0;

    // duty cycle control
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_duty_cycle <= 4'd5;
        end
        else begin
            if(increase_duty && r_duty_cycle < 4'd9) begin
                r_duty_cycle <= r_duty_cycle + 1;
            end

            if(decrease_duty && r_duty_cycle > 4'd0) begin
                r_duty_cycle <= r_duty_cycle - 1;
            end
        end
    end

    // 10Mhz PWM gen
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter_pwm <= 0;
        end
        else begin
            if(r_counter_pwm >= 4'd9) begin // 100Mhz / 10 -> 10Mhz
                r_counter_pwm <= 0;
            end
            else begin
                r_counter_pwm <= r_counter_pwm + 1;
            end
        end
    end

    assign pwm_out = (r_counter_pwm < r_duty_cycle); // duty 결정
    assign pwm_led = pwm_out;
    assign duty_cycle = r_duty_cycle;
endmodule
