`timescale 1ns / 1ps

module tb_my_btn_debounce();

    reg r_btnC;
    reg r_clk;
    reg r_reset;
    wire[1:0] w_led;

    my_btn_debounce u_my_btn_debounce(
        .btnC(r_btnC),
        .clk(r_clk),
        .reset(r_reset),
        .led(w_led)
    );

    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk; // 5ns 마다 clk 반전 -> 100MHz clock gen
    end

    initial begin
        r_reset = 1;
        r_btnC = 0;
        #100
        r_reset = 0;
        #100 

        r_btnC = 1;
        #5_000_000; // 5ms
        r_btnC = 0;
        #20_000_000 // 20ms

        r_btnC = 1;
        #1_000_000; // 1ms
        r_btnC = 0;
        #20_000_000 // 20ms

        r_btnC = 1; 
        #13_000_000; // 10ms clean_btn = 1
        r_btnC = 0;
        #5_000_000   // 5ms
        r_btnC = 1;
        #20_000_000 // 20ms 

        r_btnC = 0;
        #1_000_000  // 1ms
        r_btnC = 1;
        #20_000_000 // 20ms

        r_btnC = 0;
        #13_000_000; // 10ms clean_btn = 0
        r_btnC = 1;
        #5_000_000  // 5ms
        r_btnC = 0;
        #20_000_000

        #1000;

        $display("==================== simulation finish ====================", $time);
        $finish;
    end
endmodule
