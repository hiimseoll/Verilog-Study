`timescale 1ns / 1ps

module tb_uart_rx();

    reg clk;
    reg reset;
    reg RsRx;
    wire led0;

    top u_top(
        .clk(clk),
        .reset(reset),
        .RsRx(RsRx),
        .led0(led0)
    );

    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clk gen

    localparam CLK_FREQUENCY = 100_000_000; // 100MHz
    localparam BIT_PER_CLK_NUM = CLK_FREQUENCY / 9600; // 10ns per 1 bit = 10416
    localparam CLK_PERIOD_10NS = 10; // 10ns
    localparam BAUD_PERIOD = BIT_PER_CLK_NUM * CLK_PERIOD_10NS; // sim wait 시간: 104160


    // UART RX SIM
    // ASCII 'U', 'u' 
    initial begin
        #00 reset = 1; RsRx = 1; clk = 0;
        #100; reset = 0;
        #200; // state->IDLE

        // --- 1. 'l' (0x6C: 0110_1100) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 2. 'e' (0x65: 0110_0101) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 3. 'd' (0x64: 0110_0100) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 4. '0' (0x30: 0011_0000) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 5. 'o' (0x6F: 0110_1111) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 6. 'n' (0x6E: 0110_1110) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 7. '\r' (0x0D: 0000_1101) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop

        // --- 7. '\l' (0x0D: 0000_1010) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop


        #100000;

        // --- 1. 'l' (0x6C: 0110_1100) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 2. 'e' (0x65: 0110_0101) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 3. 'd' (0x64: 0110_0100) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 4. '0' (0x30: 0011_0000) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 5. 'o' (0x6F: 0110_1111) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 6. 'f' (0x6E: 0110_0110) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 6. 'f' (0x6E: 0110_0110) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop
        #BAUD_PERIOD;

        // --- 7. '\r' (0x0D: 0000_1101) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop

        // --- 7. '\l' (0x0D: 0000_1010) ---
        #BAUD_PERIOD RsRx = 0; // start
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 1; 
        #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; #BAUD_PERIOD RsRx = 0; 
        #BAUD_PERIOD RsRx = 1; // stop

        #1000; 

        $display("UART RX text complete.");
        $finish;
    end
endmodule
