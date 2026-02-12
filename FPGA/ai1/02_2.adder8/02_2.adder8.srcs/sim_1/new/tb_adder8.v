`timescale 1ns / 1ps

module tb_adder8();

    reg [7:0] r_a;
    reg [7:0] r_b;
    reg r_cin; // 1 bit
    wire [7:0] w_sum;
    wire w_carry_out;

    adder8 u_adder8(
        .a(r_a),
        .b(r_b),
        .cin(r_cin),
        .sum(w_sum),
        .carry_out(w_carry_out)
    );

    initial begin
        r_a = 8'b00000000; r_b = 8'b00000000; r_cin = 0;
        #10 r_a = 8'b11000001; r_b = 8'b10000011;
        #10 $finish;
    end

endmodule
