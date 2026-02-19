`timescale 1ns / 1ps

module tb_top();
    //  입력 신호 define
    reg clk;
    reg reset;        // sw[15]
    reg [2:0] btn;    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR
    reg [7:0] sw;

    // 출력 신호 define
    wire [7:0] seg;
    wire [3:0] an;
    wire [15:0] led;

    // DUT(Design Under Test) 인스턴스화
    top u_top(
        .clk(clk),
        .reset(reset),        // sw[15]
        .btn(btn),          // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR   
        .sw(sw),
        .seg(seg),
        .an(an),
        .led(led)
    );

    // 100MHz clock 생성(10ns 주기)
    always #5 clk = ~clk;

    task btn_press;
        input integer btn_index; // integer signed 32bit  <-> reg [31:0]
        begin
            $display ("btn_press btn: %0d start", btn_index);

            // 1. make noise(0.55ms)
            btn[btn_index] = 1; #100_000 // 0.1ms high
            btn[btn_index] = 0; #200_000 // 0.2ms low
            btn[btn_index] = 1; #150_000 // 0.15ms high
            btn[btn_index] = 0; #100_000 // 0.1ms low

            // 2. 안정 구간 11ms 유지 --> 이 구간이 지나야 clean_btn == 1
            btn[btn_index] = 1;
            #11_000_000; 

            // 3.btn을 뗀다 (10ms 이상)
            btn[btn_index] = 0;
            #11_100_000;
            $display("btn press btn: %0d release", btn_index);
        end
    endtask

    initial begin
        $monitor("time = %t mode: %b an: %b seg: %b", $time, led[15:13], an, seg);
        // led[15:13]나 an이나 seg값이 바뀌면 해당 라인을 출력.
    end

    initial begin
        // 1. initial 설정
        clk = 0;
        reset = 1;
        btn = 3'b000;
        sw = 8'b00000000;

        // 2. reset 해제
        #100;
        reset = 0;
        #100;

        // 3. mode 변경 (IDLE --> UP_COUNTER btn[0] : btnL)
        $display("MODE IDLE --> UP_COUNTER");
        btn_press(0); // btn[0]

        // 4. UP_COUNTER 동작 관찰
        #20_000_000; // 20ms

        // --------------모드변경 UP-->DOWN--------------
        $display("MODE UP_COUNTER --> DOWN_COUNTER");
        btn_press(0); // btn[0]

        // 5. DOWN_COUNTER 동작 관찰
        #10_000_000; // 10ms

        // 6. --------------모드변경 DOWN-->SLIDE_SW--------------
        $display("MODE DOWN_COUNTER --> SLIDE_SW_READ");
        btn_press(0); // btn[0]
        sw = 8'h55; // 0101 0101
        #1_000_000;
        sw = 8'hAA; // 1010 1010
        #10_000_000; // 10ms

        $display("simulation End...");
        $finish;
    end
endmodule
