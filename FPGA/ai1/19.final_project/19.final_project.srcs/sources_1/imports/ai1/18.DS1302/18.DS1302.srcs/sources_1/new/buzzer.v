`timescale 1ns / 1ps

module buzzer(
    input clk,
    input reset,
    input all_btn_press, // power on, open
    input alarm_sig,
    
    output buzzer
    );

    localparam FREQ_1K = 16'd50000;    // 50% duty
    localparam FREQ_2K = 16'd25000;
    localparam FREQ_3K = 16'd16666;
    localparam FREQ_4K = 16'd12500;

    
    localparam COUNT_70MS_4TIMES = 28_000_000;
    localparam COUNT_10MS = 1_000_000;

    localparam [63:0] ALARM_MELODY = {FREQ_2K, 16'd0, 16'd0, 16'd0};
    localparam HIGH_BEEP = 22'd75_848;
    
    reg [$clog2(COUNT_70MS_4TIMES) - 1 : 0] r_counter = 0;
    reg r_buzzer_frequency = 0;
    reg [17:0] r_clk_cnt = 0;

    reg r_play_alarm_melody = 0;
    reg r_play_beep = 0;

    wire [15:0] alarm_freq;
    wire [21:0] beep_freq;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_buzzer_frequency <= 0;
            r_counter <= 0;
            r_play_alarm_melody <= 0;
            r_play_beep <= 0;
        end
        else begin
            if(alarm_sig) begin
                r_play_alarm_melody <= 1;
            end 
            else if(all_btn_press) begin
                r_play_beep <= 1;
            end
            else if(!alarm_sig && !all_btn_press) begin
                r_clk_cnt <= 0;
                r_buzzer_frequency <= 0;
            end

            if(r_play_alarm_melody) begin
                if(r_counter < COUNT_70MS_4TIMES - 1) begin
                    if(r_clk_cnt >= alarm_freq - 1) begin
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                        r_clk_cnt <= 0;
                    end
                    else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                    r_counter <= r_counter + 1;
                end
                else begin
                    r_counter <= 0;
                    r_play_alarm_melody <= 0;
                end
            end


            if(r_play_beep) begin
                if(r_counter < COUNT_10MS - 1) begin
                    if(r_clk_cnt >= beep_freq - 1) begin
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                        r_clk_cnt <= 0;
                    end
                    else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                    r_counter <= r_counter + 1;
                end
                else begin
                    r_counter <= 0;
                    r_play_beep <= 0;
                end
            end  
        end
    end

assign alarm_freq = ALARM_MELODY[(r_counter / 7_000_000) * 16 +: 16];
assign beep_freq = HIGH_BEEP;
assign buzzer = r_buzzer_frequency; 
                    
endmodule
