`timescale 1ns / 1ps

module tick(
    input clk,
    input reset,
    input tb_mode, // test bench mode -> tick을 50ns로 설정

    output tick_50ms
    );

    parameter MAX_COUNT = 5_000_000;

    wire [$clog2(MAX_COUNT)-1:0] w_target = tb_mode ? 25'd4 : 25'd4_999_999; // 50ns : 50ms

    reg [$clog2(MAX_COUNT)-1:0] r_counter = 0; 
    reg r_tick_50ms = 1'b0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_tick_50ms <= 0;
            r_counter <= 0;            
        end else begin
            if(r_counter >= w_target) begin 
                r_counter <= 0;
                r_tick_50ms <= 1'b1;
            end else begin
                r_counter <= r_counter + 1; 
                r_tick_50ms <= 1'b0; // 다음 clk posedge에 바로 off
            end
        end
    end

    assign tick_50ms = r_tick_50ms;
endmodule
