`timescale 1ns / 1ps

module play_melody(
    input clk,
    input reset,
    input btnL, btnR, // power on, open
    
    output buzzer
    );

    localparam FREQ_1K = 16'd50000;    // 50% duty
    localparam FREQ_2K = 16'd25000;
    localparam FREQ_3K = 16'd16666;
    localparam FREQ_4K = 16'd12500;

    
    localparam COUNT_70MS_4TIMES = 28_000_000;

    localparam [63:0] POWER_ON_MELODY = {FREQ_4K, FREQ_3K, FREQ_2K, FREQ_1K};
    localparam [71:0] OPEN_MELODY = {18'd191_570, 18'd151_975, 18'd127_551, 18'd90_252};
    
    reg [$clog2(COUNT_70MS_4TIMES) - 1 : 0] r_counter = 0;
    reg r_buzzer_frequency = 0;
    reg [17:0] r_clk_cnt = 0;

    reg r_play_power_on = 0;
    reg r_play_open = 0;

    wire [15:0] power_on_current_freq;
    wire [17:0] open_current_freq;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_buzzer_frequency <= 0;
            r_counter <= 0;
            r_play_power_on <= 0;
            r_play_open <= 0;
        end
        else begin
            if(btnL) begin
                r_play_power_on <= 1;
            end 
            else if(btnR) begin
                r_play_open <= 1;
            end
            else if(!r_play_open && !r_play_power_on) begin
                r_clk_cnt <= 0;
                r_buzzer_frequency <= 0;
            end

            if(r_play_power_on) begin
                if(r_counter < COUNT_70MS_4TIMES - 1) begin
                    if(r_clk_cnt >= power_on_current_freq - 1) begin
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
                    r_play_power_on <= 0;
                end
            end


            if(r_play_open) begin
                if(r_counter < COUNT_70MS_4TIMES - 1) begin
                    if(r_clk_cnt >= open_current_freq - 1) begin
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
                    r_play_open <= 0;
                end
            end  
        end
    end

assign power_on_current_freq = POWER_ON_MELODY[(r_counter / 7_000_000) * 16 +: 16];
assign open_current_freq = OPEN_MELODY[(r_counter / 7_000_000) * 18 +: 18];
assign buzzer = r_buzzer_frequency; 
                    
endmodule
