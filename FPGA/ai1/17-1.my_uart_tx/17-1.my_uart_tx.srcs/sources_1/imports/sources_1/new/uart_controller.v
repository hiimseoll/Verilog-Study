`timescale 1ns / 1ps

module uart_controller #(
    parameter BAUD_VALUE = 9600,
    parameter DEBOUNCE_LIMIT_VALUE =  1_000_000
)(
    input clk,
    input reset,
    input [7:0] send_data,
    input rx,
    input btn,

    output tx,
    output [7:0] rx_data,
    output rx_done
    );

    wire w_tx_busy;
    wire w_tx_done;
    wire w_tx_start;
    wire [7:0] w_tx_data;
    wire w_clean_btn;

    reg btn_ff1;
    reg btn_ff2;

    data_sender u_data_sender(
        .clk(clk),
        .reset(reset),
        .start_trigger(w_clean_btn),
        .send_data(send_data),
        .tx_busy(w_tx_busy),
        .tx_done(w_tx_done),
        .tx_start(w_tx_start),
        .tx_data(w_tx_data)
    );

    uart_tx #(
        .BAUD(BAUD_VALUE)
    ) u_uart_tx(
        .clk(clk),
        .reset(reset),
        .tx_data(w_tx_data),
        .tx_start(w_tx_start),
        .tx(tx),
        .tx_done(w_tx_done),
        .tx_busy(w_tx_busy)
    );

    debouncer #(
        .DEBOUNCE_LIMIT(DEBOUNCE_LIMIT_VALUE)
    ) u_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn_ff2),
        .clean_btn(w_clean_btn)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            btn_ff1 <= 0;
            btn_ff2 <= 0;
        end 
        else begin
            btn_ff1 <= btn;
            btn_ff2 <= btn_ff1;
        end
    end
endmodule
