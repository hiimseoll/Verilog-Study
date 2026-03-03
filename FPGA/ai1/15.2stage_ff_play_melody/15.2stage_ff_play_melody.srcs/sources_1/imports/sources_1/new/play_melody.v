`timescale 1ns / 1ps

module play_melody(
    input clk,
    input reset,
    input btnL, btnC, btnR,      // 도(261.63Hz), 레(293.66Hz), 미(329.63Hz)
          btnU, btnD, btnJ3,     // 파(349.23Hz), 솔(392.09Hz), 라(440.00Hz)
    
    output buzzer
    );

    // input clk: 100MHz
    // output frequency:
    // (100MHz / 원하는 주파수) / 2

    localparam DO = 22'd191_112;    // 50% duty
    localparam RE = 22'd170_265;
    localparam MI = 22'd151_685;
    localparam FA = 22'd143_172;
    localparam SO = 22'd127_551;
    localparam RA = 22'd113_636;

    reg [21:0] r_clk_cnt[5:0]; // 2차원 array
    reg [5:0] r_buzzer_frequency;
    
    // 2단 동기화기를 위한 reg 선언
    reg [4:0] ff1; // 1단계 ff
    reg [4:0] ff2; // 2단계 ff (시스템에서 사용할 안전한 신호)


    wire [5:0] btn_array = {btnJ3, btnD, btnU, btnR, btnC, btnL};

    integer i; // integer: signed 32bit / reg [31:0]: unsigned 32bit

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            // 동기화기 ff reset
            ff1 <= 5'd0;
            ff2 <= 5'd0;
            for(i = 0; i < 6; i = i + 1) begin
                r_clk_cnt[i] <= 22'd0;
                r_buzzer_frequency[i] <= 1'b0;
            end
        end
        else begin // 10ms마다 상승 에지 클럭
            // 동기화
            ff1 <= btn_array;  // 1단계: sampling
            ff2 <= ff1;        // 2단계 안정화된 출력 신호 전달 

            // 도(btnL)
            if(!ff2[0]) begin
                r_clk_cnt[0] <= 0;
                r_buzzer_frequency[0] <= 1'b0;
            end
            else if(r_clk_cnt[0] >= DO - 1) begin
                r_clk_cnt[0] <= 0;
                r_buzzer_frequency[0] <= ~r_buzzer_frequency[0];
            end
            else begin
                r_clk_cnt[0] <= r_clk_cnt[0] + 1;
            end

            // 레(btnC)
            if(!ff2[1]) begin
                r_clk_cnt[1] <= 0;
                r_buzzer_frequency[1] <= 1'b0;
            end
            else if(r_clk_cnt[1] >= RE - 1) begin
                r_clk_cnt[1] <= 0;
                r_buzzer_frequency[1] <= ~ r_buzzer_frequency[1];
            end
            else begin
                r_clk_cnt[1] <= r_clk_cnt[1] + 1;
            end

            // 미(btnR)
            if(!ff2[2]) begin
                r_clk_cnt[2] <= 0;
                r_buzzer_frequency[2] <= 1'b0;
            end
            else if(r_clk_cnt[2] >= MI - 1) begin
                r_clk_cnt[2] <= 0;
                r_buzzer_frequency[2] <= ~ r_buzzer_frequency[2];
            end
            else begin
                r_clk_cnt[2] <= r_clk_cnt[2] + 1;
            end

            // 파(btnU)
            if(!ff2[3]) begin
                r_clk_cnt[3] <= 0;
                r_buzzer_frequency[3] <= 1'b0;
            end
            else if(r_clk_cnt[3] >= FA - 1) begin
                r_clk_cnt[3] <= 0;
                r_buzzer_frequency[3] <= ~ r_buzzer_frequency[3];
            end
            else begin
                r_clk_cnt[3] <= r_clk_cnt[3] + 1;
            end

            // 솔(btnD)
            if(!ff2[4]) begin
                r_clk_cnt[4] <= 0;
                r_buzzer_frequency[4] <= 1'b0;
            end
            else if(r_clk_cnt[4] >= SO - 1) begin
                r_clk_cnt[4] <= 0;
                r_buzzer_frequency[4] <= ~ r_buzzer_frequency[4];
            end
            else begin
                r_clk_cnt[4] <= r_clk_cnt[4] + 1;
            end

            // 라(btnJ3)
            if(!ff2[5]) begin
                r_clk_cnt[5] <= 0;
                r_buzzer_frequency[5] <= 1'b0;
            end
            else if(r_clk_cnt[5] >= RA - 1) begin
                r_clk_cnt[5] <= 0;
                r_buzzer_frequency[5] <= ~ r_buzzer_frequency[5];
            end
            else begin
                r_clk_cnt[5] <= r_clk_cnt[5] + 1;
            end
        end
    end

assign buzzer = |r_buzzer_frequency; // 베릴로그 축약 OR 연산자 | r_buzzer_frequency
//    assign buzzer = r_buzzer_frequency[0] | r_buzzer_frequency[1] |
//                    r_buzzer_frequency[2] | r_buzzer_frequency[3] |
//                    r_buzzer_frequency[4] | r_buzzer_frequency[5];
                    // 0 : 5개 비트가 모두 0일때만 0
                    // 1 : 하나라도 눌리면
                    
endmodule
