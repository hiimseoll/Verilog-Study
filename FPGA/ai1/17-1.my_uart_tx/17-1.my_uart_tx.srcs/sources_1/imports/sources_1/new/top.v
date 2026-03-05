`timescale 1ns / 1ps

module top #(
    parameter BAUD_MODIFY = 9600,
    parameter DEBOUNCE_LIMIT_MODIFY = 1_000_000
)(
    input clk,
    input reset,
    input btnL,
    input RsRx, // RS232 RX
    input [7:0] sw,
    
    output RsTx
    );

    uart_controller #(
        .BAUD_VALUE(BAUD_MODIFY),
        .DEBOUNCE_LIMIT_VALUE(DEBOUNCE_LIMIT_MODIFY)
    ) u_uart_controller(
        .clk(clk),
        .reset(reset),
        .send_data(sw),
        .rx(RsRx),
        .btn(btnL),
        .tx(RsTx),
        .rx_data(),
        .rx_done()
    );
endmodule
