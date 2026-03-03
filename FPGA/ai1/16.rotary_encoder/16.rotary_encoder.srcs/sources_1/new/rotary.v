`timescale 1ns / 1ps

module rotary(
    input clk,
    input reset,
    input clean_s1, clean_s2, clean_key,

    output [15:0] led
    );

    reg [1:0] r_direction = 2'b00; // cw: 01, ccw: 10
    reg [1:0] r_previous_state = 2'b00;
    reg [1:0] r_current_state = 2'b00;
    reg [7:0] r_counter = 8'h00;


    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_direction <= 2'b00;
            r_previous_state <= 2'b00;
            r_current_state <= 2'b00;
            r_counter <= 8'h00;
        end
        else begin
            r_previous_state <= r_current_state;
            r_current_state <= {clean_s1, clean_s2};

            case({r_previous_state, r_current_state})
                4'b0010, 
                4'b1011, 
                4'b1101, 
                4'b0100: begin
                    r_counter <= r_counter + (r_counter < 8'hFF) ?  1 : 0; // overflow 방지
                    r_direction <= 2'b01; // cw indicator
                end
                4'b0001,
                4'b0111,
                4'b1110,
                4'b1000: begin
                    r_counter <= r_counter - (r_counter > 8'h00) ?  1 : 0; // underflow 방지
                    r_direction <= 2'b10; // ccw indicator
                end
                default: begin
                    r_direction = 2'b00;
                end
            endcase
        end
    end

    // key
    reg r_led_toggle = 1'b0;
    reg r_previous_key = 1'b0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_led_toggle <= 1'b0;
            r_previous_key <= 1'b0;
        end
        else begin
            r_previous_key <= clean_key;
            if(!r_previous_key && clean_key) begin
                r_led_toggle <= ~r_led_toggle;
            end
        end
    end

    assign led[15:14] = r_direction;
    assign led[13] = r_led_toggle;
    assign led[12:8] = 5'b00000; // off
    assign led[7:0] = r_counter;
endmodule
