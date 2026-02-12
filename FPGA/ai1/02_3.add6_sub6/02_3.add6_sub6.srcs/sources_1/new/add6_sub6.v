`timescale 1ns / 1ps

module add6_sub6(
    input [5:0] a,
    input [5:0] b,
    input cin, // 1 bit
    input select_t,
    output [5:0] sum,
    output carry_out
    );

    wire [5:0] w_carry;
    wire [5:0] w_b;
    wire w_cin;
    wire select;

    assign select = !select_t;

    xor_gate u_xor_gate_cin(
        .x(select),
        .y(cin),
        .z(w_cin)
    );

    xor_gate u_xor_gate0(
        .x(select),
        .y(b[0]),
        .z(w_b[0])
    );

    full_adder u_full_adder0(
        .a(a[0]),
        .b(w_b[0]),
        .cin(w_cin),
        .sum(sum[0]),
        .carry_out(w_carry[0])
    ); 

    xor_gate u_xor_gate1(
        .x(select),
        .y(b[1]),
        .z(w_b[1])
    );

    full_adder u_full_adder1(
        .a(a[1]),
        .b(w_b[1]),
        .cin(w_carry[0]),
        .sum(sum[1]),
        .carry_out(w_carry[1])
    );

    xor_gate u_xor_gate2(
        .x(select),
        .y(b[2]),
        .z(w_b[2])
    );

    full_adder u_full_adder2(
        .a(a[2]),
        .b(w_b[2]),
        .cin(w_carry[1]),
        .sum(sum[2]),
        .carry_out(w_carry[2])
    ); 

    xor_gate u_xor_gate3(
        .x(select),
        .y(b[3]),
        .z(w_b[3])
    );

    full_adder u_full_adder3(
        .a(a[3]),
        .b(w_b[3]),
        .cin(w_carry[2]),
        .sum(sum[3]),
        .carry_out(w_carry[3])
    ); 

    xor_gate u_xor_gate4(
        .x(select),
        .y(b[4]),
        .z(w_b[4])
    );

    full_adder u_full_adder4(
        .a(a[4]),
        .b(w_b[4]),
        .cin(w_carry[3]),
        .sum(sum[4]),
        .carry_out(w_carry[4])
    ); 

    xor_gate u_xor_gate5(
        .x(select),
        .y(b[5]),
        .z(w_b[5])
    );

    full_adder u_full_adder5(
        .a(a[5]),
        .b(w_b[5]),
        .cin(w_carry[4]),
        .sum(sum[5]),
        .carry_out(w_carry[5])
    ); 

    xor_gate u_xor_gate6(
        .x(select),
        .y(w_carry[5]),
        .z(carry_out)
    );
endmodule
