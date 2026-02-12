`timescale 1ns / 1ps

module tb_decoder();

    reg [1:0] r_a; 
    wire [3:0] w_led;

        // 2. 검증 모듈 인스턴스화
    mux2_1 u_mux2_1(
        .a(r_a), // named port 방식
        .b(r_b),
        .select(r_select),
        .out(w_out)
    );


    decoder u_decoer(
        .a(r_a),
        .led(w_led)
    );

    initial begin
        r_a = 2'b00;
        #10 r_a = 2'b01;
        #10 r_a = 2'b10;
        #10 r_a = 2'b11;
        #10 $finish;
    end
endmodule

