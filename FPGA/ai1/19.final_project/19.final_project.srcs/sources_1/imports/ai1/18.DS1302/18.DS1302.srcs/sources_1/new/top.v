`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input btnL,
    input btnC,
    input btnR,
    input s1,
    input s2,
    input key,
    input RsRx,

    inout data_io,
    inout dht11_data,

    output RsTx,
    output ce,
    output sclk,
    output [3:0] an,
    output [7:0] seg,
    output buzzer,
    output pwm_louver,
    output pwm_fan
);
    wire w_clean_s1;
    wire w_clean_s2;
    wire w_clean_key;
    wire w_clean_btnL;
    wire w_clean_btnC;
    wire w_clean_btnR;
    wire [13:0] w_out_time;
    wire w_alarm_sig;
    wire w_req_set_alarm;
    wire w_req_set_time;
    wire w_rx_valid;
    wire [7:0] w_rx_data;
    wire [13:0] w_parsed_time;
    wire [7:0] w_send_data;
    wire [7:0] w_target_temp;
    wire w_is_editing;
    wire [7:0] w_current_humi;
    wire [7:0] w_current_temp;
    wire w_dht_valid;
    wire [3:0] w_fan_speed;
    wire [13:0] w_alarm_time;

    DS1302 u_DS1302(
        .clk(clk),
        .reset(reset),
        .req_set(w_req_set_time),
        .in_time(w_parsed_time),
        .out_time(w_out_time), 
        .data_io(data_io),
        .ce(ce),
        .sclk(sclk)
    );
    debouncer u_debouncer_s1(
        .clk(clk),
        .reset(reset),
        .btn(s1),
        .clean_btn(w_clean_s1)
    );

    debouncer u_debouncer_s2(
        .clk(clk),
        .reset(reset),
        .btn(s2),
        .clean_btn(w_clean_s2)
    );

    debouncer u_debouncer_key(
        .clk(clk),
        .reset(reset),
        .btn(key),
        .clean_btn(w_clean_key)
    );

    debouncer u_debouncer_btnL(
        .clk(clk),
        .reset(reset),
        .btn(btnL),
        .clean_btn(w_clean_btnL)
    );

    debouncer u_debouncer_btnC(
        .clk(clk),
        .reset(reset),
        .btn(btnC),
        .clean_btn(w_clean_btnC)
    );

    debouncer u_debouncer_btnR(
        .clk(clk),
        .reset(reset),
        .btn(btnR),
        .clean_btn(w_clean_btnR)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .btn_mode(w_clean_btnC),                        
        .current_time(w_out_time), 
        .current_temp(w_current_temp),
        .current_hum(w_current_humi),
        .target_temp(w_target_temp),     
        .is_editing(w_is_editing),                    
        .an(an),            
        .seg(seg)     
    );

    alarm_controller u_alarm_controller(
        .clk(clk),
        .reset(reset),
        .req_set_alarm(w_req_set_alarm), 
        .parsed_time(w_parsed_time), 
        .current_rtc_time(w_out_time), 
        .btn_stop(w_clean_btnR), 
        .alarm_out(w_alarm_sig),
        .target_alarm_time(w_alarm_time)
    );

    uart_cmd_parser u_uart_cmd_parser(
        .clk(clk),
        .reset(reset),
        .rx_valid(w_rx_valid),
        .in_data(w_rx_data), 
        .req_set_time(w_req_set_time),    
        .req_set_alarm(w_req_set_alarm), 
        .parsed_time(w_parsed_time)
    );

    uart_controller u_uart_controller(
        .clk(clk),
        .reset(reset),
        .current_time(w_out_time), 
        .alarm_time(w_alarm_time),   
        .target_temp(w_target_temp),  
        .current_temp(w_current_temp), 
        .current_humi(w_current_humi), 
        .fan_speed(w_fan_speed),    
        .dht_valid(w_dht_valid),
        .rx(RsRx),
        .tx(RsTx), 
        .rx_data(w_rx_data),
        .rx_done(w_rx_valid)
    );

    buzzer u_buzzer(
        .clk(clk),
        .reset(reset),
        .all_btn_press(btnC || btnR || btnL),
        .alarm_sig(w_alarm_sig),
        .buzzer(buzzer)
    );

    louver_controller u_louver_controller(
        .clk(clk),
        .reset(rset),
        .btn(w_clean_btnL),
        .pwm_louver(pwm_louver)
    );

    rotary_temp_set u_rotary_temp_set(
        .clk(clk),
        .reset(reset),
        .clean_s1(w_clean_s1), 
        .clean_s2(w_clean_s2), 
        .clean_key(w_clean_key),
        .editing_temp(w_target_temp),  
        .confirmed_temp(w_target_temp), 
        .is_editing(w_is_editing)
    );

    dcmotor u_dcmotor(
        .clk(clk),
        .reset(reset),
        .current_temp(w_current_temp),
        .target_temp(w_target_temp),
        .pwm_fan(pwm_fan),
        .r_duty_cycle(w_fan_speed)
    );

    dht11 u_dht11(
        .clk(clk),
        .reset(reset),
        .dht11_data(dht11_data),
        .humidity(w_current_humi),
        .temperature(w_current_temp),
        .data_valid(w_dht_valid)   
    );
endmodule