`timescale 1ns / 1ps

// 4bit + 4bit => carry, sum(4bit)
module add4_sub4(
    input [7:0] sw,
    input select,   // 1: add, 0: sub
    output [3:0] sum,
    output carry_out
    );

    // assign {carry_out, sum[3:0]} = sw[3:0] + sw[7:4]; 
    // 결합연산자 / sum에 넣고 overflow되면 carry_out 으로 


    assign {carry_out, sum[3:0]} = select ? sw[3:0] + sw[7:4] :
                                            sw[3:0] + ~sw[7:4] + 4'b1; 
endmodule
