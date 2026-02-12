`timescale 1ns / 1ps

module tb_adder4(); // 시뮬레이션에선 입출력x

    reg [3:0] a;    // 시뮬에서 입력은 reg
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire carry_out;

    adder4 u_adder4(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        #00 a = 0; b = 0; cin = 0;
        #10 a = 0; b = 2;
        #10 a = 7; b = 9;
        #10 a = 9; b = 9;
        #10 a = 7; b = 7;
        for (integer i = 0; i < 20; i = i + 1) begin
            #10 a = i; b = i + 1; 
        end
        #10 $finish;
    end
endmodule
