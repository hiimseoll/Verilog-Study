`timescale 1ns / 1ps

module top(
    input clk,
    input reset,        // sw[15]
    input [2:0] btn,    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR
    input [7:0] sw,
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led
    //output [2:0] JXADC  // led 연결(외부출력)
    );

    wire [2:0] w_debounced_btn;
    wire [13:0] w_seg_data; // max 9999의 binary 자릿수

    btn_debounce u_btn_debounce(
        .clk(clk),
        .reset(reset),
        .btn(btn),   // 3개의 버튼 입력: btn[2:0] → 각각 btnL, btnC, btnR
        .debounced_btn(w_debounced_btn)
    );

    control_tower u_control_tower(
        .clk(clk),
        .reset(reset),
        .btn(w_debounced_btn),
        .sw(sw),
        .seg_data(w_seg_data),
        .led(led)
    );

    /*
    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),        // sw[15]
        .in_data(w_seg_data),
        .an(an),
        .seg(seg)
    );
    */
    
    //assign JXADC = w_debounced_btn;
    //assign led = w_debounced_btn;
endmodule
