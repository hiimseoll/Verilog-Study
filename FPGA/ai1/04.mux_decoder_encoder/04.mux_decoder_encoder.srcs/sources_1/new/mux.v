`timescale 1ns / 1ps

// module mux2_1( // 2 : 1 mux / 입력 값 중 하나를 선택해 출력함.
//     input a, b, select, // 입력 1, 2와 select
//     output out // 출력
//     );

//     assign out = select ? a : b;

// module mux2_1( // 2 : 1 mux / 입력 값 중 하나를 선택해 출력함.
//     input a, b, select, // 입력 1, 2와 select
//     output out // 출력
//     );

//     reg r_out; // 1 bit 플립플롭

//     // always @(select or a, b) begin // 절차형 할당문
//     //     if(select) r_out = a;
//     //     else r_out = b;
//     // end

//     always @(*) begin // input 변하면 실행? *
//         case(select)
//             1'b1: r_out = a;
//             1'b0: r_out = b;
//         endcase
//     end

//     assign out = r_out; // r_out을 out에 연결


module mux2_1( // 4 bit mux
    input [3:0] a,
    input [3:0] b,
    input select,
    output [3:0] out // 출력
    );

    reg [3:0] r_out;

    // always @(select or a, b) begin // 절차형 할당문
    //     if(select) r_out = a;
    //     else r_out = b;
    // end

    always @(*) begin // input 변하면 실행? *
        case(select)
            1'b1: r_out = a;
            1'b0: r_out = b;
        endcase
    end

    assign out = r_out; // r_out을 out에 연결
endmodule
