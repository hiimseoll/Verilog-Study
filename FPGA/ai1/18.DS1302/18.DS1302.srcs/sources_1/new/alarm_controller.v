module alarm_controller(
    input clk,
    input reset,
    
    input req_set_alarm,        
    input [13:0] parsed_time,   
    
    input [13:0] current_rtc_time, 
    
    input btn_stop, // 알람 끄기
    output reg alarm_out 
    );

    reg [13:0] target_alarm_time;
    reg alarm_enabled;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            target_alarm_time <= 0;
            alarm_enabled <= 0;
            alarm_out <= 0;
        end else begin
            // 1. 새로운 알람 설정 
            if(req_set_alarm) begin
                target_alarm_time <= parsed_time;
                alarm_enabled <= 1; // 새 알람 활성화
                alarm_out <= 0;     // 출력 초기화
            end
            
            // 2. 알람 시간 도달 판별
            if(alarm_enabled && (current_rtc_time == target_alarm_time)) begin
                alarm_out <= 1;
            end
            

            if(btn_stop) begin
                alarm_out <= 0;
                alarm_enabled <= 0; 
            end
        end
    end
endmodule