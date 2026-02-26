`timescale 1ns / 1ps

module blink(
    input clk,
    input reset,
    output seg_dot
    );
    
    parameter MAX_COUNT = 100_000_000;

    reg [$clog2(MAX_COUNT) - 1 : 0] r_counter;
    reg r_seg_dot;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_seg_dot <= 0;
        end else begin
            if(r_counter >= MAX_COUNT - 1) begin
                r_counter <= 0;
                r_seg_dot <= ~r_seg_dot;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end
    
    assign seg_dot = r_seg_dot;
endmodule
