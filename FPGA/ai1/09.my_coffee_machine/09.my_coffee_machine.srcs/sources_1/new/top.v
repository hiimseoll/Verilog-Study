`timescale 1ns / 1ps

module top #(
    parameter VALUE_BY_MODE = 1_000_000, 
    parameter DYNAMIC_DRIVE_COUNT = 100_000, 
    parameter EXTRACTION_COUNT = 500_000_000, 
    parameter IDLE_COUNT = 10_000_000)(

    input clk,
    input reset,
    input [2:0] btn,

    output [7:0] seg,
    output [3:0] an
    );

    wire [15:0] w_coin_val;
    wire w_coffee_make;
    wire w_coin_return;
    wire [2:0] w_clean_btn;
    wire [2:0] w_btn_pulse;
    wire w_seg_en;
    wire w_coffee_out;

    neg_pulse u_neg_pulse(
        .clk(clk),
        .reset(reset),
        .clean_btn(w_clean_btn),
        .btn_pulse(w_btn_pulse)
    );

    coffee_machine u_coffee_machine(
    .clk(clk),                 // 100Mhz
    .reset(reset),               // reset btn (active high)
    .coin(w_btn_pulse[0]),                // 동전 투입 (100원 단위)
    .return_coin_btn(w_btn_pulse[1]),      // 동전 반환 버튼
    .coffee_btn(w_btn_pulse[2]),          
    .coffee_out(w_coffee_out),          // 커피 배출 완료 센서 신호

    .coin_val(w_coin_val),  // 현재 금액 표시
    .seg_en(w_seg_en),          // FND 활성화 신호
    .coffee_make(w_coffee_make),     // 커피 제조 시작 신호
    .coin_return(w_coin_return)      // 동전 반환 동작 신호
    );

    fnd_controller #(
        .DYNAMIC_DRIVE_COUNT(DYNAMIC_DRIVE_COUNT), 
        .EXTRACTION_COUNT(EXTRACTION_COUNT), 
        .IDLE_COUNT(IDLE_COUNT)) 
    u_fnd_controller(
    .clk(clk),
    .reset(reset),
    .idle(w_coffee_make),
    .in_data(w_coin_val),
    .seg_en(w_seg_en),
    .extraction_end(w_coffee_out),
    .an(an),
    .seg(seg)
    );

    debouncer #(.MAX_COUNT(VALUE_BY_MODE)) u_debouncer1 (
    .btn(btn[0]),
    .clk(clk),
    .reset(reset),
    .clean_btn(w_clean_btn[0])
    );

    debouncer #(.MAX_COUNT(VALUE_BY_MODE)) u_debouncer2 (
    .btn(btn[1]),
    .clk(clk),
    .reset(reset),
    .clean_btn(w_clean_btn[1])
    );

    debouncer #(.MAX_COUNT(VALUE_BY_MODE)) u_debouncer3 (
    .btn(btn[2]),
    .clk(clk),
    .reset(reset),
    .clean_btn(w_clean_btn[2])
    );

endmodule

module neg_pulse(
    input clk,
    input reset,
    input [2:0] clean_btn,
    output [2:0] btn_pulse
);
    reg [2:0] r_btn_reg; // negedge detection용


    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_btn_reg <= 3'b000;
        end else begin
            r_btn_reg[0] <= clean_btn[0];
            r_btn_reg[1] <= clean_btn[1];
            r_btn_reg[2] <= clean_btn[2];
        end
    end

    assign btn_pulse[0] = (!clean_btn[0] && r_btn_reg[0]);
    assign btn_pulse[1] = (!clean_btn[1] && r_btn_reg[1]);
    assign btn_pulse[2] = (!clean_btn[2] && r_btn_reg[2]);
endmodule
