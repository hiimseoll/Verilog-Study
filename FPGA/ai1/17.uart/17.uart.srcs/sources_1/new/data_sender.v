`timescale 1ns / 1ps

module data_sender(
    input clk,
    input reset,
    input start_trigger,
    input [7:0] send_data,
    input tx_busy,
    input tx_done,

    output reg [7:0] tx_data,
    output reg tx_start
    );

    reg [6:0] r_bit_index = 7'd0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            tx_start <= 0;
            r_bit_index <= 7'd0;
        end
        else begin
            if(start_trigger && !tx_busy) begin
                tx_start <= 1;

                if(r_bit_index > 7'd9) begin
                    r_bit_index <= 0;
                    tx_data <= send_data;
                end
                else begin
                    tx_data <= send_data + r_bit_index;
                    r_bit_index <= r_bit_index + 1;
                end
            end
            else begin
                tx_start <= 0;
            end
        end
    end
endmodule
