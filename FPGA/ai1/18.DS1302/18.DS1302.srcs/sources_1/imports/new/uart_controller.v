`timescale 1ns / 1ps

module uart_controller(
    input clk,
    input reset,
    input rx,

    output [7:0] rx_data,
    output rx_done
    );

    uart_rx #(
        .BAUD(9600)
    ) u_uart_rx(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(rx_data),
        .rx_done(rx_done)
    );
endmodule
