`timescale 1ns / 1ps


module adder8(
    input [7:0] a,
    input [7:0] b,
    input cin, // 1 bit
    output [7:0] sum,
    output carry_out
    );

    wire [6:0] w_carry;

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
        .carry_out(w_carry[3])
    ); // names installation

    full_adder u_full_adder4(
        .a(a[4]),
        .b(b[4]),
        .cin(w_carry[3]),
        .sum(sum[4]),
        .carry_out(w_carry[4])
    ); // names installation

    full_adder u_full_adder5(
        .a(a[5]),
        .b(b[5]),
        .cin(w_carry[4]),
        .sum(sum[5]),
        .carry_out(w_carry[5])
    ); // names installation

    full_adder u_full_adder6(
        .a(a[6]),
        .b(b[6]),
        .cin(w_carry[5]),
        .sum(sum[6]),
        .carry_out(w_carry[6])
    ); // names installation

    full_adder u_full_adder7(
        .a(a[7]),
        .b(b[7]),
        .cin(w_carry[6]),
        .sum(sum[7]),
        .carry_out(carry_out)
    ); // names installation


endmodule
