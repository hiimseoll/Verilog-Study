`timescale 1ns / 1ps

module louver_controller (
    input clk,
    input reset,
    input btn,
    output reg pwm_louver
);
    reg r_louver_state;
    reg r_direction;

    always @(posedge btn or posedge reset) begin
        if (reset) begin
            r_louver_state <= 1'b0;
        end
        else begin
            r_louver_state <= ~r_louver_state;
        end
    end

    reg [20:0] r_counter;
    reg [20:0] r_duty = 21'd100_000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_counter <= 21'd0;
            pwm_louver <= 1'b0;
            r_direction <= 0;
            r_duty <= 21'd100_000;
        end else begin
            if(r_counter  >= 21'd1_999_999) begin
                r_counter <= 0;

                if(r_louver_state) begin
                    if(!r_direction) begin
                        if(r_duty + 666 >= 21'd200_000) begin
                            r_direction <= 1;
                        end
                        else begin
                            r_duty <= r_duty + 666;
                        end
                    end
                    else begin
                        if(r_duty - 666 <= 21'd100_000) begin
                            r_direction <= 0;
                        end
                        else begin
                            r_duty <= r_duty - 666;
                        end
                    end
                end
            end
            else begin
                r_counter <= r_counter + 1;
            end

            pwm_louver <= (r_counter < r_duty) ? 1'b1 : 1'b0;
        end
    end

endmodule
