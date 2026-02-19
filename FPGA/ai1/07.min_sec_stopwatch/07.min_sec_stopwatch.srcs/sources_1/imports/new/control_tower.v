`timescale 1ns / 1ps

module control_tower(
    input clk,
    input reset,        // sw[15]
    input tick,
    input [2:0] btn,    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR
    output [11:0] seg_data,
    output mode
    );


    // mode define
    parameter STOPWATCH = 2'b01;
    parameter PAUSE = 2'b10;
    parameter RESET = 2'b11;

    reg r_prev_btnL = 0;
    reg [1:0] r_mode = 2'b00;
    reg [26:0] r_counter; // 1s 측정 위한 카운터
    reg [5:0] r_sec_counter; // 60s가 될 때 마다 1씩 증가
    reg [5:0] r_min_counter;

    // mode check
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_prev_btnL <= 0;
            r_mode <= 0;
        end else begin
            if(btn[0]) begin
                r_mode <= STOPWATCH;
            end else if(btn[1]) begin
                r_mode <= PAUSE;
            end else if(btn[2]) begin
                r_mode <= RESET;
            end
        end
    end

    // stopwatch
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_sec_counter <= 0;
            r_min_counter <= 0;
        end else if(r_mode == STOPWATCH) begin                
            if(r_counter == 27'd100_000_00 - 1) begin // 1s check
                r_counter <= 0;
                if(r_sec_counter >= 6'd59) begin
                    r_sec_counter <= 0;
                    if(r_min_counter >= 6'd59) begin
                        r_min_counter <= 0;
                    end else begin
                        r_min_counter <= r_min_counter + 1;
                    end
                end else begin
                    r_sec_counter <= r_sec_counter + 1;
                end
            end else begin
                r_counter <= r_counter + 1;
            end
        end else if(r_mode == PAUSE) begin                 
            
        end else begin                                              // 3. RESET
            r_counter <= 0;
            r_sec_counter <= 0;
            r_min_counter <= 0;
        end
    end


    assign seg_data = (r_min_counter * 100) + r_sec_counter;
    // (r_mode == STOPWATCH) ? r_60_counter :
    //                    (r_mode == PAUSE) ? r_60_counter : 0;


endmodule
