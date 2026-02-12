`timescale 1ns / 1ps

module tb_button_debounce();

    // 상수 #define 같은 것
    parameter CLK_FREQ = 100_000_000; // 100MHz
    parameter CLK_PERIOD = 10; // 10ns (100MHz의 1주기 10ns)
    parameter BTN_PRESS_LIMIT= 30_000_000; // 30ms        1ms = 1,000,000ns;

    reg r_btnC;
    reg r_clk;
    reg r_reset;
    wire [1:0] w_led;

    top_btn u_top_btn(
        .clk(r_clk),
        .reset(r_reset),
        .btnC(r_btnC),
        .led(w_led)
    );

    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk; // 5ns 마다 clk 반전 -> 100MHz clock gen
    end

    initial begin
        r_reset = 1;
        r_btnC = 0;
        #100;       // reset 여유시간 100ns
        r_reset = 0;
        // btn input gen
        $display ("[%0t] start btn noise generation...", $time); // timestamp
        #100 r_btnC = 1;
        #200 r_btnC = 0;
        #300 r_btnC = 1;
        #120 r_btnC = 0;
        #500 
            r_btnC = 1;
        #(BTN_PRESS_LIMIT); // 30ms
        #100;
        
        if(w_led !== 2'b00) begin // led가 바뀌었으면
            $display("[%0t] TEST PASSED led changed", $time);
        end else begin
            $display("[%0t] TEST FAILED led not changed", $time);
        end
        #1000;
        $display("==================== simulation finish ====================", $time);
        $finish;
    end
    

endmodule
