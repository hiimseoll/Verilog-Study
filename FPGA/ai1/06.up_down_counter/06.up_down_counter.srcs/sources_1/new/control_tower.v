`timescale 1ns / 1ps

module control_tower(
    input clk,
    input reset,        // sw[15]
    input tick,
    input [2:0] btn,    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR
    input [7:0] sw,
    output [13:0] seg_data,
    output reg [15:14] led
    );


    // mode define
    parameter UP_COUNTER = 2'b01;
    parameter DOWN_COUNTER = 2'b10;
    parameter SLIDE_SW_READ = 2'b11;

    reg r_prev_btnL = 0;
    reg [1:0] r_mode = 2'b00;
    reg [19:0] r_counter; // 10ms 측정 위한 카운터 -> 10ns * 1_000_000
    reg [13:0] r_10ms_counter; // 10ms가 될 때 마다 1씩 증가 -> 9999

    // mode check
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_prev_btnL <= 0;
            r_mode <= 0;
        end else begin
            if(btn[0] && !r_prev_btnL) begin
                r_mode <= (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1; 
            end
        end
        r_prev_btnL <= btn[0];
    end

    // up counter
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_10ms_counter <= 0;
        end else if(r_mode == UP_COUNTER) begin                     // 1. add logic
            if(r_counter == 20'd1_000_000 - 1) begin // 10ms check
                r_counter <= 0;

                if(r_10ms_counter >= 9999) begin // 9999도달시 0
                    r_10ms_counter <= 0;
                end else begin
                    r_10ms_counter <= r_10ms_counter + 1;
                end

                //led[13:0] <= r_10ms_counter;
            end else begin
                r_counter <= r_counter + 1;
            end
        end else if(r_mode == DOWN_COUNTER) begin                   // 1. sub logic
            if(r_counter == 20'd1_000_000 - 1) begin // 10ms check
                r_counter <= 0;

                if(r_10ms_counter <= 0) begin// 9999도달시 0
                    r_10ms_counter <= 9999;
                end else begin
                    r_10ms_counter <= r_10ms_counter - 1;
                end

                //led[13:0] <= r_10ms_counter; // led로 count 표시
            end else begin
                r_counter <= r_counter + 1;
            end
        end else begin                                              // 3. SLIDE_SW_READ
            r_counter <= 0;
            r_10ms_counter <= 0;
        end
    end

    // led mode display
    always @(r_mode) begin
        case(r_mode)
            UP_COUNTER: begin
                led[15:14] = UP_COUNTER;
            end
            DOWN_COUNTER: begin
                led[15:14] = DOWN_COUNTER;
            end
            SLIDE_SW_READ: begin
                led[15:14] = SLIDE_SW_READ;
            end
            default: begin
                led[15:14] = 2'b00;
            end
        endcase
    end

    assign seg_data  = (r_mode == UP_COUNTER) ? r_10ms_counter :
                       (r_mode == DOWN_COUNTER) ? r_10ms_counter : sw;


endmodule
