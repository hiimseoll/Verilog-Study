`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input RsRx,

    output led0
    );

    wire [7:0] w_rx_data;
    wire w_rx_done;

    control_tower u_control_tower(
        .clk(clk),
        .reset(reset),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done),
        .led0(led0)
    );

    uart_controller u_uart_controller(
        .clk(clk),
        .reset(reset),
        .rx(RsRx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );

endmodule
