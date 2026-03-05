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

    wire [7:0] w_rx_data;
    wire w_rx_done;
    wire [13:0] w_seg_data;
    wire [2:0] w_clean_btn;

    debouncer u_debouncer1(
        .clk(clk),
        .reset(reset),
        .btn(btn[0]),
        .clean_btn(w_clean_btn[0])
    );
    debouncer u_debouncer2(
        .clk(clk),
        .reset(reset),
        .btn(btn[1]),
        .clean_btn(w_clean_btn[1])
    );
    debouncer u_debouncer3(
        .clk(clk),
        .reset(reset),
        .btn(btn[2]),
        .clean_btn(w_clean_btn[2])
    );

    control_tower u_control_tower(
        .clk(clk),
        .reset(reset),
        .btn(w_clean_btn),
        .sw(sw),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done),
        .seg_data(w_seg_data),
        .led(led)
    );

    uart_controller u_uart_controller(
        .clk(clk),
        .reset(reset),
        .send_data(8'h30), // tmp 0
        .rx(RsRx),
        .tx(RsTx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );

    assign uartTx = RsTx;
    assign uartRx = RsRx;
endmodule
