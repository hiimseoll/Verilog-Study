module alarm_controller(
    input clk,
    input reset,
    
    input req_set_alarm,        
    input [13:0] parsed_time,   
    
    input [13:0] current_rtc_time, 
    
    input btn_stop, 
    output reg alarm_out,
    output reg [13:0] target_alarm_time
    );

    reg alarm_enabled;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            target_alarm_time <= 0;
            alarm_enabled <= 0;
            alarm_out <= 0;
        end 
        else begin
            if(req_set_alarm) begin
                target_alarm_time <= parsed_time;
                alarm_enabled <= 1; 
                alarm_out <= 0;  
            end
            else if(!alarm_enabled) begin
                target_alarm_time <= 14'd0;
            end

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