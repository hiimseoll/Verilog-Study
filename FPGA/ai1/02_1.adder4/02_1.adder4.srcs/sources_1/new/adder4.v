`timescale 1ns / 1ps

module adder4(
    input [3:0] a,
    input [3:0] b,
    input cin, // 1 bit
    output [3:0] sum,
    output carry_out
    );

    wire [2:0] w_carry;

    full_adder u_full_adder0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .carry_out(w_carry[0])
    ); // names installation

    full_adder u_full_adder1(
        .a(a[1]),
        .b(b[1]),
        .cin(w_carry[0]),
        .sum(sum[1]),
        .carry_out(w_carry[1])
    ); // names installation

    full_adder u_full_adder2(
        .a(a[2]),
        .b(b[2]),
        .cin(w_carry[1]),
        .sum(sum[2]),
        .carry_out(w_carry[2])
    ); // names installation

    full_adder u_full_adder3(
        .a(a[3]),
        .b(b[3]),
        .cin(w_carry[2]),
        .sum(sum[3]),
        .carry_out(carry_out)
    ); // names installation

endmodule
