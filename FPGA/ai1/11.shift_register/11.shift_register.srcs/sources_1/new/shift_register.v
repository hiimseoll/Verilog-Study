`timescale 1ns / 1ps

module shift_register(
    input clk,
    input reset,
    input in,
    output out
    );

    reg [6:0] sr7;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sr7 <= 7'b0000000;
        end
        else begin
            sr7 <= {sr7[5:0], in}; // shift reg
        end
    end

    assign out = (sr7 == 7'b1010111);
endmodule
