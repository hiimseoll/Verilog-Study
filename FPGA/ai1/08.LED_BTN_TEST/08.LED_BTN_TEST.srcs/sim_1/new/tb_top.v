`timescale 1ns / 1ps

module tb_top();
    reg clk;
    reg reset;
    reg btn;
    reg tb_mode;

    wire [15:0] led;

    // T = 10ns / F = 100MHz clock gen
    always #5 clk = ~clk;

    top u_top(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .tb_mode(tb_mode),
        .led(led)
    );

    initial begin
        // 1. initial 설정
        clk = 0;
        reset = 1;
        btn = 0;
        tb_mode = 0;

        // 2. reset 해제 // tb_mode = 1
        #100;
        reset = 0;
        #100;
        tb_mode = 1;
        #100;

        // 3. 문제1
        btn = 1;
        #100;
        btn = 0;
        #1000;

        // 3. 문제2
        btn = 1;
        #100;
        btn = 0;
        #1000;

        // 3. 문제3
        btn = 1;
        #100;
        btn = 0;
        #1000;

        // 3. 문제4
        btn = 1;
        #100;
        btn = 0;
        #1000;

        // 3. 문제1로 복귀
        btn = 1;
        #100;
        btn = 0;
        #1000;
    end
endmodule
