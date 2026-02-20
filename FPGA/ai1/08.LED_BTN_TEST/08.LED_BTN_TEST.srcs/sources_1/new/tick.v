`timescale 1ns / 1ps

module tick(
    input clk,
    input reset,
    output tick_50ms
    );

    parameter MAX_COUNT = 5_000_000; // for 50ms 

    reg r_tick_50ms = 1'b0;
    reg [$clog2(MAX_COUNT)-1:0] r_counter = 0; 

    always @(posedge clk, posedge reset) begin
        if(reset) begin // reset
            r_tick_50ms <= 0;
            r_counter <= 0;            
        end else begin
            if(r_counter >= MAX_COUNT - 1) begin
                r_counter <= 0;
                r_tick_50ms <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick_50ms <= 1'b0;
            end
        end
    end

    assign tick_50ms = r_tick_50ms;
endmodule
