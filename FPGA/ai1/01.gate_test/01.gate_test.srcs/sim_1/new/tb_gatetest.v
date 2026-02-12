`timescale 1ns / 1ps // ~ 1.999ns

module tb_gatetest();
    reg i_a;  // i_a = 1bit 메모리
    reg i_b;
    wire [4:0] o_led; // o_led[0~4]

    gatetest u_gatetest( // u_gatetest라는 이름으로 인스턴스 생성
        .a(i_a), // named port mapping 방식
        .b(i_b),
        .led(o_led)
    );

    //  a b
    //  0 0
    //  0 1
    //  1 0
    //  1 1

    initial begin
        #00 i_a = 1'b0; i_b = 1'b0;
        #20 i_a = 1'b0; i_b = 1'b1;
        #20 i_a = 1'b1; i_b = 1'b0;
        #20 i_a = 1'b1; i_b = 1'b1;
        #20 $stop;
    end 
endmodule