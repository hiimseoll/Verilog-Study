`timescale 1ns / 1ps

module tb_mux2_1();

    reg [3:0] r_a; 
    reg [3:0] r_b;
    reg r_select;
    wire [3:0] w_out;

        // 2. 검증 모듈 인스턴스화
    mux2_1 u_mux2_1(
        .a(r_a), // named port 방식
        .b(r_b),
        .select(r_select),
        .out(w_out)
    );


    // 3. test scenario 작성
    initial begin
        // 초기값 설정
        r_a = 4'hA; r_b = 4'h3; r_select = 0;
        // 결과 출력
        $monitor("Time=%0t, | r_select=%b | r_a=%h | r_b=%h | w_out=%h", $time, r_select, r_a, r_b, w_out); 
        // --- select: 1 (a출력)
        #10 r_a = 4'hE; r_b = 4'h7; r_select = 1; // w_out = E
        #10 r_a = 4'hF; r_b = 4'hA; r_select = 1; // w_out  = F
        // --- select: 0 (b출력)
        #10 r_a = 4'h7; r_b = 4'hA; r_select = 0;
        #10 r_a = 0; r_b = 1; r_select = 0;
        #10 $finish;
    end

    // reg r_a, r_b, r_select;
    // wire w_out;


    // // 2. 검증 모듈 인스턴스화
    // mux2_1 u_mux2_1(
    //     .a(r_a), // named port 방식
    //     .b(r_b),
    //     .select(r_select),
    //     .out(w_out)
    // );


    // // 3. test scenario 작성
    // initial begin
    //     // 초기값 설정
    //     r_a = 0; r_b = 0; r_select = 0;
    //     // 결과 출력
    //     $monitor("Time=%0t, | r_select=%b | r_a=%b | r_b=%b | w_out=%b", $time, r_select, r_a, r_b, w_out); 
    //     // --- select: 1 (a출력)
    //     #10 r_a = 1; r_b = 0; r_select = 1; // w_out == 1 (a)
    //     #10 r_a = 0; r_b = 1; r_select = 1; // w_out == 0 (a)
    //     // --- select: 0 (b출력)
    //     #10 r_a = 1; r_b = 0; r_select = 0; // w_out == 0 (b)
    //     #10 r_a = 0; r_b = 1; r_select = 0; // w_out == 1 (b)
    //     #10 $finish;
    // end

endmodule
