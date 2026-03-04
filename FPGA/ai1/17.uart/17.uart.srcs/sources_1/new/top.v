`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    input RsRx, // RS232 RX
    
    output RsTx,
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led,
    output uartTx, uartRx // JB1, JB2 
    );

    uart_controller u_uart_controller(
        .clk(clk),
        .reset(reset),
        .send_data(8'h30), // tmp 0
        .rx(RsRx),
        .tx(RsTx),
        .rx_data(),
        .rx_done()
        );

        assign uartTx = RsTx;
        assign uartRx = RsRx;
endmodule
