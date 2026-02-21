`timescale 1ns / 1ps

module debouncer(
    input btn,
    input tick,
    input reset,
    output clean_btn
    );

    reg [1:0] r_counter = 0;
    reg r_clean_btn = 1'b0;

always @(posedge tick, posedge reset) begin
        if(reset) begin
            r_clean_btn <= 0;
            r_counter <= 0; 
        end else begin
            if(btn == r_clean_btn) begin

                r_counter <= 0; 
                
            end else begin

                r_counter <= r_counter + 1;

                if(r_counter >= 1) begin // 50ms tick을 사용해 50ms 디바운싱
                    r_clean_btn <= btn;
                    r_counter <= 0;
                end

            end
        end
    end

    assign clean_btn = r_clean_btn;
endmodule
