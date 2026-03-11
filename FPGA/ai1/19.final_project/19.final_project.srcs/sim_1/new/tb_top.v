`timescale 1ns / 1ps

module tb_top;

    // Inputs
    reg clk;
    reg reset;
    reg btnL, btnC, btnR;
    reg s1, s2, key;
    reg RsRx;

    // Inouts
    wire data_io;
    wire dht11_data;

    // Outputs
    wire RsTx;
    wire ce;
    wire sclk;
    wire [3:0] an;
    wire [7:0] seg;
    wire buzzer;
    wire pwm_louver;
    wire pwm_fan;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk), 
        .reset(reset), 
        .btnL(btnL), 
        .btnC(btnC), 
        .btnR(btnR), 
        .s1(s1), 
        .s2(s2), 
        .key(key), 
        .RsRx(RsRx), 
        .data_io(data_io), 
        .dht11_data(dht11_data), 
        .RsTx(RsTx), 
        .ce(ce), 
        .sclk(sclk), 
        .an(an), 
        .seg(seg), 
        .buzzer(buzzer), 
        .pwm_louver(pwm_louver), 
        .pwm_fan(pwm_fan)
    );

    // Inout 풀업 저항 모사 (High-Z 상태 방지)
    pullup(dht11_data);
    pullup(data_io);

    // 100MHz Clock Generation
    always #5 clk = ~clk; 

    // UART 전송 Task (9600 Baudrate)
    task send_uart_byte(input [7:0] data);
        integer i;
        begin
            RsRx = 0; // Start bit
            #(104167); // 1초 / 9600 = 약 104.167us
            for (i=0; i<8; i=i+1) begin
                RsRx = data[i];
                #(104167);
            end
            RsRx = 1; // Stop bit
            #(104167);
        end
    endtask

    initial begin
        // 초기화
        clk = 0; reset = 1; 
        btnL = 0; btnC = 0; btnR = 0; 
        s1 = 0; s2 = 0; key = 0; 
        RsRx = 1;

        #100; // 리셋 유지
        reset = 0;
        #1000;

        // 시나리오 1: UART를 통한 시간 설정 테스트 ("setT1230")
        send_uart_byte("s");
        send_uart_byte("e");
        send_uart_byte("t");
        send_uart_byte("T");
        send_uart_byte("1");
        send_uart_byte("2");
        send_uart_byte("3");
        send_uart_byte("0");

        
        
        // ==================================================
        // 시나리오 2: DC 모터 (팬) OFF / LOW / HIGH 동작 테스트
        // ==================================================
        $display("--- Scenario 3: DC Motor Test ---");

        // [Test 1] OFF 상태 (현재 온도 24 <= 목표 온도 25)
        force uut.w_target_temp = 8'd25;
        force uut.w_current_temp = 8'd24;
        #10000; // PWM 파형 출력을 확인하기 위한 대기
        
        // [Test 2] LOW_SPEED 상태 (목표 25 < 현재 온도 27 <= 목표+4)
        force uut.w_current_temp = 8'd27;
        #10000;
        
        // [Test 3] HIGH_SPEED 상태 (현재 온도 31 > 목표+4)
        force uut.w_current_temp = 8'd31;
        #10000;

        // 테스트 종료 후 강제 주입 해제 (원래 하드웨어 로직으로 복구)
        release uut.w_target_temp;
        release uut.w_current_temp;
        
        #5000;
// ==================================================
        // 시나리오 4: 알람 설정 및 해제 (setA1230 -> 12:30 -> btnR)
        // ==================================================
        $display("--- Scenario 4: Alarm Set & Stop Test ---");

        // [Test 1] UART로 알람 시간 12:30 설정 ("setA1230" 전송)
        send_uart_byte("s");
        send_uart_byte("e");
        send_uart_byte("t");
        send_uart_byte("A");
        send_uart_byte("1");
        send_uart_byte("2");
        send_uart_byte("3");
        send_uart_byte("0");
        #10000;

        // [Test 2] 현재 시간을 12:29로 강제 설정 (알람 울리기 직전)
        // DS1302를 기다리지 않고 시간을 강제로 덮어씌웁니다.
        force uut.w_out_time = 14'd1229;
        #10000;

        // [Test 3] 현재 시간을 12:30으로 변경 -> w_alarm_sig ON 기대
        force uut.w_out_time = 14'd1230;
        
        // 알람이 울리는 것을 파형에서 확인하기 위해 충분히 대기 (약 5ms)
        #5_000_000; 

        // [Test 4] btnR (알람 종료 버튼) 입력
        // 디바운서(10ms)를 확실하게 통과하기 위해 15ms 동안 버튼을 누르고 있는 상태 모사
        btnR = 1;
        #15_000_000; 
        btnR = 0;
        
        // 알람 신호(w_alarm_sig)가 0으로 꺼지는지 확인하기 위한 대기
        #5_000_000;

        // 테스트 종료 후 시간 강제 주입 해제 (원래 RTC 하드웨어 로직으로 복구)
        release uut.w_out_time;
        
        #5000;
        $stop;
    end

endmodule