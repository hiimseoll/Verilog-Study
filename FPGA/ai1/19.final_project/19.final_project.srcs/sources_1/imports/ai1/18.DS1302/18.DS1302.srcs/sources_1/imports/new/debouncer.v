`timescale 1ns / 1ps

module debouncer #(parameter DEBOUNCE_LIMIT = 1_000_000)(
    input btn,
    input clk,
    input reset,
    output clean_btn
    );

    reg ff1, ff2;

    reg [$clog2(DEBOUNCE_LIMIT) - 1:0] r_counter = 0; // 10ms
    reg r_clean_btn = 1'b0;
    reg r_prev_clean_btn = 1'b0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            ff1 <= 0;
            ff2 <= 0;
        end else begin
            ff1 <= btn;
            ff2 <= ff1;
        end
    end

    always @(posedge clk, posedge reset) begin
            if(reset) begin
                r_prev_clean_btn <= 0;
                r_clean_btn <= 0;
                r_counter <= 0; 
            end 
            else begin
                r_prev_clean_btn <= r_clean_btn;
                
                if(ff2 == r_clean_btn) begin
                    r_counter <= 0; 
                end 
                else begin
                    r_counter <= r_counter + 1;

                    if(r_counter >= DEBOUNCE_LIMIT - 1) begin // 10ms 디바운싱
                        r_clean_btn <= ff2;
                        r_counter <= 0;
                    end
                end
            end
        end
        assign clean_btn = (r_clean_btn && !r_prev_clean_btn);
endmodule
