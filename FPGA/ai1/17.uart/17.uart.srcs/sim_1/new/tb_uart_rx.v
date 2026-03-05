`timescale 1ns / 1ps

module tb_uart_rx();

    reg clk;
    reg reset;
    reg rx;

    wire [7:0] data_out;
    wire rx_done;

    uart_rx #(
        .BAUD(9600)
    ) u_uart_rx(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clk gen

    localparam CLK_FREQUENCY = 100_000_000; // 100MHz
    localparam BIT_PER_CLK_NUM = CLK_FREQUENCY / 9600; // 10ns per 1 bit = 10416
    localparam CLK_PERIOD_10NS = 10; // 10ns
    localparam BAUD_PERIOD = BIT_PER_CLK_NUM * CLK_PERIOD_10NS; // sim wait 시간: 104160

    always @(posedge rx_done) begin
        $display("[time: %t] data_out received %h ", $time, data_out);
    end

    // UART RX SIM
    // ASCII 'U', 'u' 
    initial begin
        #00 reset = 1; rx = 1; clk = 0;
        #100; reset = 0;
        #200; // state->IDLE

        // 'U' 0x55 = 0101 0101
        #BAUD_PERIOD rx = 0; // start bit low
        #BAUD_PERIOD rx = 1; // bit[0]
        #BAUD_PERIOD rx = 0; // bit[1]
        #BAUD_PERIOD rx = 1; // bit[2]
        #BAUD_PERIOD rx = 0; // bit[3]

        #BAUD_PERIOD rx = 1; // bit[4]
        #BAUD_PERIOD rx = 0; // bit[5]
        #BAUD_PERIOD rx = 1; // bit[6]
        #BAUD_PERIOD rx = 0; // bit[7]
        #BAUD_PERIOD rx = 1; // stop bit high
        #10000000; // 1ms

        $display("UART RX text complete.");
        $finish;
    end
endmodule
