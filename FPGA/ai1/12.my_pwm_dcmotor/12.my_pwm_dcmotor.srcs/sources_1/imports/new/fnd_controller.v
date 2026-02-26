`timescale 1ns / 1ps

module fnd_controller(
    input clk,
    input reset,
    input [3:0] in_data,
    input [1:0] motor_direction,
    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100;
    wire w_toggle_direction_fnd;
    wire [6:0] w_in_data;

    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .reset(reset),
        .toggle_direction_fnd(w_toggle_direction_fnd),
        .sel(w_sel)
    );

    bin2bcd4digit u_bin2bcd4digit (
        .in_data(w_in_data),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100)
    );

    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .toggle_direction_fnd(w_toggle_direction_fnd),
        .motor_direction(motor_direction),
        .an(an),
        .seg(seg)
    );

    assign w_in_data = in_data * 7'd10;
endmodule

module fnd_digit_select(
    input clk,
    input reset,
    output reg [1:0] sel,
    output reg toggle_direction_fnd
);

    parameter COUNT_1MS_500TIMES = 500;
    parameter COUNT_1MS = 100_000;

    reg [$clog2(COUNT_1MS_500TIMES) - 1 : 0] r_500ms_counter = 0;
    reg [$clog2(COUNT_1MS) - 1 : 0] r_1ms_counter  = 0;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sel <= 0;
            r_1ms_counter <= 0;
            r_500ms_counter <= 0;
            toggle_direction_fnd <= 0;
        end else begin
            if(r_1ms_counter >= COUNT_1MS) begin
                r_1ms_counter <= 0;
                r_500ms_counter <= r_500ms_counter + 1;
                sel <= sel + 1;
            end else begin
                r_1ms_counter <= r_1ms_counter + 1;
            end

            if(r_500ms_counter >= COUNT_1MS_500TIMES) begin
                toggle_direction_fnd <= ~toggle_direction_fnd;
                r_500ms_counter <= 0;
            end
        end
    end
endmodule

module bin2bcd4digit(
    input [6:0] in_data,
    output [3:0] d1, d10, d100
);

    assign d1 = in_data % 10;
    assign d10 = (in_data / 10) % 10;
    assign d100 = (in_data / 100) % 10;
endmodule

module fnd_digit_display(
    input [1:0] digit_sel,
    input [3:0] d1, d10, d100,
    input [1:0] motor_direction,
    input toggle_direction_fnd,
    output reg [3:0] an,
    output reg [7:0] seg
);

    reg [3:0] bcd_data;

    // 숫자 선택
    always @(*) begin
        case(digit_sel)
            2'b00: bcd_data = d1;
            2'b01: bcd_data = d10;
            2'b10: bcd_data = d100;
            2'b11: begin
                if(toggle_direction_fnd) begin
                    bcd_data = 4'd13;
                end
                else if(motor_direction[0] && !motor_direction[1]) begin
                    bcd_data = 4'd10;
                end
                else if(!motor_direction[0] && motor_direction[1]) begin
                    bcd_data = 4'd11;
                end
                else begin
                    bcd_data = 4'd12;
                end
            end
            default: bcd_data = 4'b0;
        endcase
    end

    // bcd -> seg
    always @(*) begin
        case(bcd_data)
            4'd0: seg = 8'b11000000;
            4'd1: seg = 8'b11111001;
            4'd2: seg = 8'b10100100;
            4'd3: seg = 8'b10110000;
            4'd4: seg = 8'b10011001;
            4'd5: seg = 8'b10010010;
            4'd6: seg = 8'b10000010;
            4'd7: seg = 8'b11111000;
            4'd8: seg = 8'b10000000;
            4'd9: seg = 8'b10010000;
            4'd10: seg = 8'b10001110;
            4'd11: seg = 8'b10000011;
            4'd12: seg = 8'b10010010;
            4'd13: seg = 8'b11111111;
            default: seg = 8'b11111111;
        endcase
    end

    // idle 애니메이션 또는 숫자 출력 선택
    always @(*) begin
        case(digit_sel)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
            default: an = 4'b1111;
        endcase
    end

endmodule