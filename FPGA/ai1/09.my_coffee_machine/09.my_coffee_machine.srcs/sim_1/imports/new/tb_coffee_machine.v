`timescale 1ns / 1ps

module tb_coffee_machine();

    reg clk;                  // 100Mhz
    reg reset;                // reset btn (active high)
    reg [2:0] btn;
    wire [7:0] seg;
    wire [3:0] an;

    top #(
        .VALUE_BY_MODE(10), 
        .DYNAMIC_DRIVE_COUNT(10), 
        .EXTRACTION_COUNT(50), 
        .IDLE_COUNT(2))
    u_top (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .seg(seg),
        .an(an)
    );

    // 동전 투입 task : clk에 동기화
    task insert_coin;
        begin
            @(posedge clk)
            #1 btn[0] = 1;                // setup time 확보
            repeat(11) @(posedge clk);   // 3 clk 동안 유지
            #1 btn[0] = 0;
            repeat(11) @(posedge clk);  // 대기 시간
        end
    endtask

    task return_coin;
        begin
            @(posedge clk)
            #1 btn[1] = 1;                // setup time 확보
            repeat(11) @(posedge clk);   // 3 clk 동안 유지
            #1 btn[1] = 0;
            repeat(11) @(posedge clk);  // 대기 시간
        end
    endtask

    task coffee;
        begin
            @(posedge clk)
            #1 btn[2] = 1;                // setup time 확보
            repeat(11) @(posedge clk);   // 3 clk 동안 유지
            #1 btn[2] = 0;
            repeat(11) @(posedge clk);  // 대기 시간
        end
    endtask

    // 100MHz 생성
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 초기 신호 unknown(x) 방지
        clk = 0;
        reset = 1;
        btn = 3'b000;
        // --- 정상적인 reset seq ---
        #100; // 100ns 동안 reset 유지
        @(negedge clk) // 클럭이 하강 에지일 때 리셋 해제(글리치 방지)
        reset = 0;
        $display("time : %t reset rel... IDLE state: ", $time);
        #50;

        // 3. scenario: 400원 동전 투입 (IDLE --> COIN_IN --> READY)
        $display("time : %t coin insert: ", $time);
        insert_coin();      // 100원
        insert_coin();
        insert_coin();
        insert_coin();

        // 4. 커피 선택
        coffee();
        #1000;

        // 5. 동전 100원 투입 후 반환
        insert_coin();
        return_coin();
    end
endmodule
