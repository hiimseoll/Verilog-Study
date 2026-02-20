`timescale 1ns / 1ps

module tb_min_sec_stopwatch();

    // 입력
    reg r_clk;
    reg r_reset;
    reg [2:0] r_btn;

    // 출력
    wire [7:0] w_seg;
    wire [3:0] w_an;

    // DUT
    min_sec_stopwatch u_min_sec_stopwatch(
        .clk(r_clk),
        .reset(r_reset),
        .btn(r_btn),
        .seg(w_seg),
        .an(w_an)
    );
    
    // T = 10ns / F = 100MHz clock gen
    always #5 r_clk = ~r_clk;

    initial begin
        // 1. initial 설정
        r_clk = 0;
        r_reset = 1;
        r_btn = 3'b000;

        // 2. reset 해제
        #100;
        r_reset = 0;
        #100;

        // 3. 기본 WATCH MODE
        #3000
        
        // 4. STOPWATCH MODE
        r_btn[0] = 1;
        #100;
        r_btn[0] = 0;
        #3000;

        // 5. RESET -> PAUSE
        r_btn[2] = 1;
        #100;
        r_btn[2] = 0;
        #3000;

        // 6. PAUSE -> STOPWATCH
        r_btn[1] = 1;
        #100;
        r_btn[1] = 0;
        #3000;

        // 7. STOPWATCH -> PAUSE
        r_btn[1] = 1;
        #100;
        r_btn[1] = 0;
        #6000;

        // 8. PAUSE -> STOPWATCH
        r_btn[1] = 1;
        #100;
        r_btn[1] = 0;
        #3000;
    end
endmodule
