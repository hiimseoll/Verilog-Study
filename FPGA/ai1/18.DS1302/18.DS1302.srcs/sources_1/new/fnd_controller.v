`timescale 1ns / 1ps

module fnd_controller(
    input clk,
    input reset,
    
    input btn_mode,            // [시간 모드] <-> [온습도 모드] 전환 버튼 (Debounce 처리된 신호 권장)
    
    input [13:0] current_time, // 예: 14'd1229 (12시 29분)
    input [7:0] current_temp,  // 현재 온도 (DHT11)
    input [7:0] current_hum,   // 현재 습도 (DHT11)
    
    input [7:0] target_temp,   // 설정 중인 목표 온도 (Rotary Encoder)
    input is_editing,          // 1: 온도 설정 중 (인터럽트 화면 표시), 0: 평상시 화면
    
    output reg [3:0] an,       // 자릿수 선택 (Active Low)
    output reg [7:0] seg       // 세그먼트 출력 {DP, G, F, E, D, C, B, A}
    );

    // ==========================================
    // 1. 내부 타이머 및 모드 제어 FSM
    // ==========================================
    localparam COUNT_1MS = 100_000;
    
    reg [16:0] r_1ms_cnt;
    reg [8:0]  r_500ms_cnt;
    reg [1:0]  r_2sec_cnt;    // 500ms마다 카운트 (0~3) -> 2초 주기 생성
    
    reg [1:0] r_sel;          // 0~3 자릿수 멀티플렉싱용
    reg r_dp_blink;           // 1초 간격 깜빡임 플래그
    wire w_show_hum = r_2sec_cnt[1]; // 0,1(1초): 온도 / 2,3(1초): 습도 (총 2초 교차)

    reg r_display_mode;       // 0: 시간 화면, 1: 온/습도 화면
    reg r_btn_mode_prev;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_1ms_cnt <= 0; r_500ms_cnt <= 0; r_2sec_cnt <= 0;
            r_sel <= 0; r_dp_blink <= 0;
            r_display_mode <= 0; r_btn_mode_prev <= 0;
        end else begin
            // 버튼 모드 전환 (Rising Edge)
            r_btn_mode_prev <= btn_mode;
            if(!r_btn_mode_prev && btn_mode) begin
                r_display_mode <= ~r_display_mode;
            end

            // 1ms 및 500ms 틱 생성
            if(r_1ms_cnt >= COUNT_1MS - 1) begin
                r_1ms_cnt <= 0;
                r_sel <= r_sel + 1; // 1ms마다 자릿수 변경 (스캔)
                
                if(r_500ms_cnt >= 499) begin
                    r_500ms_cnt <= 0;
                    r_dp_blink <= ~r_dp_blink; // 500ms마다 토글 (1초 깜빡임)
                    r_2sec_cnt <= r_2sec_cnt + 1; 
                end else begin
                    r_500ms_cnt <= r_500ms_cnt + 1;
                end
            end else begin
                r_1ms_cnt <= r_1ms_cnt + 1;
            end
        end
    end

    // ==========================================
    // 2. 화면 상태에 따른 각 자릿수(Digit) 데이터 매핑
    // ==========================================
    reg [3:0] digit_3, digit_2, digit_1, digit_0;
    reg dp_on; // 현재 켜진 자릿수의 소수점을 켤지 말지 결정

    always @(*) begin
        // 최우선 순위: 온도 설정 중 (Rotary 조작 감지)
        if (is_editing) begin
            digit_3 = 4'd12; // 'S' (Set)
            digit_2 = 4'd13; // Blank (공백)
            digit_1 = target_temp / 10;
            digit_0 = target_temp % 10;
            dp_on   = 1'b0;
        end 
        // 기본 모드 1: 온/습도 모드
        else if (r_display_mode == 1'b1) begin
            if (w_show_hum) begin
                digit_3 = 4'd11; // 'H' (Humidity)
                digit_2 = 4'd13; // Blank
                digit_1 = current_hum / 10;
                digit_0 = current_hum % 10;
            end else begin
                digit_3 = 4'd10; // 'C' (Celsius)
                digit_2 = 4'd13; // Blank
                digit_1 = current_temp / 10;
                digit_0 = current_temp % 10;
            end
            dp_on = 1'b0;
        end 
        // 기본 모드 0: 시간 모드
        else begin
            digit_3 = current_time / 1000;
            digit_2 = (current_time / 100) % 10;
            digit_1 = (current_time / 10) % 10;
            digit_0 = current_time % 10;
            // r_sel == 2'b10 (3번째 자리, 즉 시와 분 사이)일 때만 점을 깜빡임
            dp_on = (r_sel == 2'b10) ? r_dp_blink : 1'b0;
        end
    end

    // ==========================================
    // 3. 자릿수 스캔(MUX) 및 7-Segment 디코딩
    // ==========================================
    reg [3:0] cur_digit;
    always @(*) begin
        case(r_sel)
            2'b00: begin an = 4'b1110; cur_digit = digit_0; end // 가장 오른쪽 (1의 자리)
            2'b01: begin an = 4'b1101; cur_digit = digit_1; end // 10의 자리
            2'b10: begin an = 4'b1011; cur_digit = digit_2; end // 100의 자리
            2'b11: begin an = 4'b0111; cur_digit = digit_3; end // 가장 왼쪽 (1000의 자리)
        endcase
    end

    reg [6:0] seg_char; // {G, F, E, D, C, B, A} (Active Low)
    always @(*) begin
        case(cur_digit)
            4'd0:  seg_char = 7'b1000000;
            4'd1:  seg_char = 7'b1111001;
            4'd2:  seg_char = 7'b0100100;
            4'd3:  seg_char = 7'b0110000;
            4'd4:  seg_char = 7'b0011001;
            4'd5:  seg_char = 7'b0010010;
            4'd6:  seg_char = 7'b0000010;
            4'd7:  seg_char = 7'b1111000;
            4'd8:  seg_char = 7'b0000000;
            4'd9:  seg_char = 7'b0010000;
            4'd10: seg_char = 7'b1000110; // 'C' 표시
            4'd11: seg_char = 7'b1001001; // 'H' 표시
            4'd12: seg_char = 7'b0010010; // 'S' 표시 (숫자 5와 형태 동일)
            4'd13: seg_char = 7'b1111111; // Blank (모두 끄기)
            default: seg_char = 7'b1111111;
        endcase
    end

    // 최종 세그먼트 출력 (최상위 비트는 소수점 DP, 0일 때 켜짐)
    always @(*) begin
        seg = { ~dp_on, seg_char };
    end

endmodule