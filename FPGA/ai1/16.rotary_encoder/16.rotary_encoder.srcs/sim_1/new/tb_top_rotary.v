`timescale 1ns / 1ps

module tb_top_rotary();

    reg clk;
    reg reset;
    reg s1, s2, key;

    wire [15:0] led;

    top_rotary u_top_rotary(
        .clk(clk),
        .reset(reset),
        .s1(s1),
        .s2(s2),
        .key(key),
        .led(led)
    );

    // 100Mhz clock gen
    always #5 clk = ~clk;

    // 50ns * 3 noise gen
    task gen_btn_noise(input integer sw); // 0: s1, 1: s2
        begin
            repeat(3) begin
                if(sw) begin
                    s2 = ~s2;
                end
                else if(!sw) begin
                    s1 = ~s1;
                end
                else begin
                    key = ~key;
                end
                #50;
            end
        end
    endtask

    initial begin
        // reset
        clk = 0;
        reset = 1;
        s1 = 0;
        s2 = 0;
        key = 0;
        #100;
        reset = 0;
        #100;

        // CW 00 --> 10 --> 11 --> 01 --> 00
        $display("CW TEST start");
        gen_btn_noise(0); 
        s1 = 1;
        #3000; // 200 cycle(10us * 200 = 2000ns): noise보다 긴 3000ns 대기.
        
    end
endmodule
