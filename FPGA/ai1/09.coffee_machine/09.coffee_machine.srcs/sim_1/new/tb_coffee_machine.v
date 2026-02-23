`timescale 1ns / 1ps

module tb_coffee_machine();


    reg clk;                  // 100Mhz
    reg reset;                // reset btn (active high)
    reg coin;                // 동전 투입 (100원 단위)
    reg return_coin_btn;      // 동전 반환 버튼
    reg coffee_btn;      
    reg coffee_out;           // 커피 배출 완료 센서 신호

    wire [15:0] coin_val;  // 현재 금액 표시
    wire seg_en;          // FND 활성화 신호
    wire coffee_make;     // 커피 제조 시작 신호
    wire coin_return ;     // 동전 반환 동작 신호

    coffee_machine u_coffee_machine(
        .clk(clk),              
        .reset(reset),           
        .coin(coin),    
        .return_coin_btn(return_coin_btn),
        .coffee_btn(coffee_btn),
        .coffee_out(coffee_out),        

        .coin_val(coin_val),
        .seg_en(seg_en),  
        .coffee_make(coffee_make),
        .coin_return(coin_return)
    );

    // 동전 투입 task : clk에 동기화
    task insert_coin;
        begin
            @(posedge clk)
            #1 coin = 1;                // setup time 확보
            repeat(3) @(posedge clk);  // 3 clk 동안 유지
            #1 coin = 0;
            repeat(10) @(posedge clk);  // 대기 시간
        end
    endtask

    // 100MHz 생성
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 초기 신호 unknown(x) 방지
        clk = 0;
        reset = 1;
        coin = 0;
        return_coin_btn = 0;
        coffee_btn = 0;
        coffee_out = 0;
        //--- 정상적인 reset seq ---
        #100; // 100ns 동안 reset 유지
        @(negedge clk) // 클럭이 하강 에지일 때 리셋 해제(글리치 방지)
        reset = 0;
        $display("time : %t reset rel... IDLE state: ", $time);
        #50;

        // 3. scenario: 300원 동전 투입 (IDLE --> COIN_IN --> READY)
        $display("time : %t coin insert: ", $time);
        insert_coin();      // 100원
        insert_coin();
        insert_coin();

        //READY 확인
        #20;
        if(coin_val >= 300) begin
            $display("time : %t current READY coin_val: %d ... ", $time, coin_val);
        end else begin
            $display("time : %t error coin_val: %d ...", $time, coin_val);
        end
        // coffee_btn 누르면 READY --> COFFEE --> READY
        @(posedge clk);
        #1 coffee_btn = 1;
        @(posedge clk);
        #1 coffee_btn = 0;
        $display("time : %t coffee_btn pressed...", $time);
    end
endmodule
