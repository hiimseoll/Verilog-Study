`timescale 1ns / 1ps

module fnd_controller(
    input clk,
    input reset,        // sw[15]
    input tick,
    input [13:0] in_data,
    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1;
    wire [3:0] w_d10;
    wire [3:0] w_d100;
    wire [3:0] w_d1000;

    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .tick(tick),
        .reset(reset),
        .sel(w_sel)
    );

    bin2bcd4digit u_bin2bcd4digit(
        .in_data(in_data),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000)
    );

    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000 (w_d1000),
        .an(an),
        .seg(seg)
    );
endmodule

// -------------------------------------------------------
// 1ms마다 fnd를 display하기 위해 digit 한 자리씩 선택하는 logic
// 4ms까지는 잔상 효과 있음.
// -------------------------------------------------------
module fnd_digit_select(
    input clk,
    input reset,
    input tick,
    output reg [1:0] sel        // 00 01 10 11 : 1ms마다 바뀜.
);

    reg[$clog2(100_000):0] r_1ms_counter = 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sel <= 0;
            r_1ms_counter <= 0;
        end else begin
            if(r_1ms_counter == 100_000 - 1) begin // 1ms
                r_1ms_counter <= 0;
                sel <= sel + 1;
            end else begin
                r_1ms_counter <= r_1ms_counter + 1;
            end
        end
    end
endmodule

// ------------------------------------------------------------------
// input [13:0] in_data : 14 bit fnd에 9999 까지 표현 하기 위한 bin size
// 0~9999 천/백/십/일 자리숫자 0~9까지 BCD로 4 bit 표현
// ------------------------------------------------------------------
module bin2bcd4digit(
    input [13:0] in_data,
    output [3:0] d1,
    output [3:0] d10,
    output [3:0] d100,
    output [3:0] d1000
);

    assign d1 = in_data % 10;
    assign d10 = (in_data / 10) % 10;
    assign d100 = (in_data / 100) % 10;
    assign d1000 = (in_data / 1000) % 10;

endmodule

module fnd_digit_display(
    input [1:0] digit_sel,
    input [3:0] d1,
    input [3:0] d10,
    input [3:0] d100,
    input [3:0] d1000,
    output reg [3:0] an,
    output reg [7:0] seg
);

    reg [3:0] bcd_data;
    
    always @(digit_sel) begin // digit_sel 값이 바뀔때 실행
        case(digit_sel)
            2'b00: begin
                bcd_data <= d1;
                an <= 4'b1110;  // 첫 번째 digit
            end
            2'b01: begin
                bcd_data <= d10;
                an <= 4'b1101;  // 두 번째 digit
            end
            2'b10: begin
                bcd_data <= d100;
                an <= 4'b1011;  // 세 번째 digit
            end
            2'b11: begin
                bcd_data <= d1000;
                an <= 4'b0111;  // 네 번째 digit
            end
            default: begin
                bcd_data <= 4'b0000;
                an <= 4'b1111;  // fnd 모두 off
            end
        endcase
    end

    always @(bcd_data) begin // bcd_data 변경 시 실행
        case(bcd_data)
            4'd0: begin
                seg <= 8'b11000000; // 0
            end
            4'd1: begin
                seg <= 8'b11111001; // 1
            end
            4'd2: begin
                seg <= 8'b10100100; // 2
            end
            4'd3: begin
                seg <= 8'b10110000; // 3
            end
            4'd4: begin
                seg <= 8'b10011001; // 4
            end
            4'd5: begin
                seg <= 8'b10010010; // 5
            end
            4'd6: begin
                seg <= 8'b10000010; // 6
            end
            4'd7: begin
                seg <= 8'b11111000; // 7
            end
            4'd8: begin
                seg <= 8'b10000000; // 8
            end
            4'd9: begin
                seg <= 8'b10010000; // 8
            end
            default: begin
                seg <= 8'b11111111; 
            end
        endcase
    end
endmodule