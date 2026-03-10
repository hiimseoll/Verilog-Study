`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input btnL,
    input btnC,
    input btnR,
    inout data_io,
    input RsRx,

    output ce,
    output sclk,
    output [13:0] led,
    output [3:0] an,
    output [7:0] seg,
    output buzzer
);

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

    reg req_read;

    DS1302 u_DS1302(
        .clk(clk),
        .reset(reset),
        .req_set(w_req_set_time),
        .req_read(req_read),
        .in_time(w_parsed_time),
        .out_time(w_out_time), 
        .data_io(data_io),
        .ce(ce),
        .sclk(sclk)
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
        .current_temp(8'd25),
        .current_hum(8'd60),
        .target_temp(8'd30),     
        .is_editing(0),                    
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
        .alarm_out(w_alarm_sig) 
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
        .rx(RsRx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_valid)
    );

    buzzer u_buzzer(
        .clk(clk),
        .reset(reset),
        .all_btn_press(btnC || btnR),
        .alarm_sig(w_alarm_sig),
        .buzzer(buzzer)
    );

    reg [$clog2(100_000_000) - 1 : 0] r_counter;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            req_read <= 0;
        end else begin
            if(r_counter >= 100_000_000 - 1) begin
            r_counter <= 0;
            req_read <= 1;
            end else begin
            req_read <= 0;
            r_counter <= r_counter + 1;
            end
        end
    end
endmodule