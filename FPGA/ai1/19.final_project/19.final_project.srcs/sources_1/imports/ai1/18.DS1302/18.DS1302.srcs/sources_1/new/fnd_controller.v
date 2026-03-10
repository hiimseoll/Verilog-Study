`timescale 1ns / 1ps

module fnd_controller(
    input clk,
    input reset,
    
    input btn_mode,            
    
    input [13:0] current_time, 
    input [7:0] current_temp,  // 현재 온도 (DHT11)
    input [7:0] current_hum,   // 현재 습도 (DHT11)
    
    input [7:0] target_temp,   
    input is_editing,          
    
    output reg [3:0] an,      
    output reg [7:0] seg   
    );


    localparam COUNT_1MS = 100_000;
    
    reg [16:0] r_1ms_cnt;
    reg [8:0]  r_500ms_cnt;
    reg [1:0]  r_2sec_cnt;    
    
    reg [1:0] r_sel;          
    reg r_dp_blink;           
    wire w_show_hum = r_2sec_cnt[1]; 

    reg r_display_mode;       // 0: time, 1: temp,humi

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_1ms_cnt <= 0; r_500ms_cnt <= 0; r_2sec_cnt <= 0;
            r_sel <= 0; r_dp_blink <= 0;
            r_display_mode <= 0;
        end
        else begin
    
            if(btn_mode) begin
                r_display_mode <= ~r_display_mode;
            end

            // 1ms, 500ms tick
            if(r_1ms_cnt >= COUNT_1MS - 1) begin
                r_1ms_cnt <= 0;
                r_sel <= r_sel + 1; 
                
                if(r_500ms_cnt >= 499) begin
                    r_500ms_cnt <= 0;
                    r_dp_blink <= ~r_dp_blink; // dp 500ms toggle
                    r_2sec_cnt <= r_2sec_cnt + 1; 
                end
                else begin
                    r_500ms_cnt <= r_500ms_cnt + 1;
                end
            end
            else begin
                r_1ms_cnt <= r_1ms_cnt + 1;
            end
        end
    end

    reg [3:0] digit_3, digit_2, digit_1, digit_0;
    reg dp_on; 

    always @(*) begin

        if (is_editing) begin
            digit_3 = 4'd12;
            digit_2 = 4'd13; 
            digit_1 = target_temp / 10;
            digit_0 = target_temp % 10;
            dp_on   = 1'b0;
        end 

        else if (r_display_mode == 1'b1) begin
            if (w_show_hum) begin
                digit_3 = 4'd11; 
                digit_2 = 4'd13; 
                digit_1 = current_hum / 10;
                digit_0 = current_hum % 10;
            end else begin
                digit_3 = 4'd10;
                digit_2 = 4'd13;
                digit_1 = current_temp / 10;
                digit_0 = current_temp % 10;
            end
            dp_on = 1'b0;
        end 
        // 기본 모드 0: 시간 모드
        else begin
            digit_3 = current_time / 14'd1000;
            digit_2 = (current_time / 14'd100) % 14'd10;
            digit_1 = (current_time / 14'd10) % 14'd10;
            digit_0 = current_time % 14'd10;
            
            dp_on = (r_sel == 2'b10) ? r_dp_blink : 1'b0;
        end
    end


    reg [3:0] cur_digit;
    always @(*) begin
        case(r_sel)
            2'b00: begin an = 4'b1110; cur_digit = digit_0; end 
            2'b01: begin an = 4'b1101; cur_digit = digit_1; end 
            2'b10: begin an = 4'b1011; cur_digit = digit_2; end 
            2'b11: begin an = 4'b0111; cur_digit = digit_3; end 
        endcase
    end

    reg [6:0] seg_char;
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
            4'd10: seg_char = 7'b1000110; // C
            4'd11: seg_char = 7'b0001001; // H
            4'd12: seg_char = 7'b0010010; // S
            4'd13: seg_char = 7'b1111111; 
            default: seg_char = 7'b1111111;
        endcase
    end

    always @(*) begin
        seg = { ~dp_on, seg_char }; // dp 합치기
    end

endmodule