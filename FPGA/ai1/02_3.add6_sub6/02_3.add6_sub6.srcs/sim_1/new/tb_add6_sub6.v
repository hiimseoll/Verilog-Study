`timescale 1ns / 1ps

module tb_add6_sub6();
    reg [5:0] r_a;
    reg [5:0] r_b;
    reg r_cin; // 1 bit
    reg r_select_t;
    wire [5:0] w_sum;
    wire w_carry_out;

    add6_sub6 u_add6_sub6(
        .a(r_a),
        .b(r_b),
        .cin(r_cin),
        .select_t(r_select_t),
        .sum(w_sum),
        .carry_out(w_carry_out)
    );

    initial begin
        r_a = 6'b000000; r_b = 6'b000000; r_cin = 0; r_select_t = 0;
        #10 r_a = 6'b100001; r_b = 6'b100000; r_select_t = 0;
        #10 r_a = 6'b100001; r_b = 6'b100000; r_select_t = 1;
        #10 $finish;
    end

endmodule
