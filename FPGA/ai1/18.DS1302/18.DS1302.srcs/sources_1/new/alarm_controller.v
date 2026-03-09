module alarm_controller(
    input clk,
    input reset,
    
    // UART FSM에서 오는 신호
    input req_set_alarm,        
    input [13:0] parsed_time,   
    
    // DS1302에서 실시간으로 읽어오는 현재 시간 (10진수 14비트, 예: 'd1229)
    input [13:0] current_rtc_time, 
    
    input btn_stop, // 알람 끄기 버튼 (Posedge 처리된 신호)
    output reg alarm_out // LED나 부저 등에 연결될 알람 신호
    );

    reg [13:0] target_alarm_time;
    reg alarm_enabled;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            target_alarm_time <= 0;
            alarm_enabled <= 0;
            alarm_out <= 0;
        end else begin
            // 1. 새로운 알람 설정 (기존 알람 덮어쓰기)
            if(req_set_alarm) begin
                target_alarm_time <= parsed_time;
                alarm_enabled <= 1; // 새 알람 활성화
                alarm_out <= 0;     // 출력 초기화
            end
            
            // 2. 알람 시간 도달 판별
            if(alarm_enabled && (current_rtc_time == target_alarm_time)) begin
                alarm_out <= 1;
            end
            
            // 3. 버튼 입력 시 알람 종료 및 설정 해제
            if(btn_stop) begin
                alarm_out <= 0;
                alarm_enabled <= 0; // 등록된 알람 무효화
            end
        end
    end
endmodule