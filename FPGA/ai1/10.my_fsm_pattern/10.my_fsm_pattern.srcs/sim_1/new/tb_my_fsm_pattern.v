`timescale 1ns / 1ps

module tb_my_fsm_pattern();
    //input
    reg clk;
    reg reset;
    reg in;

    //output
    wire out;

    // 1. 테스트할 모듈을 인스턴스화
    my_fsm_pattern u_my_fsm_pattern(
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // 2. clk을 생성 (100Mhz: 1주고 10ns (High: 5ns, Low: 5ns))
    always #5 clk = ~clk;

    // 값이 변하면 값을 출력한다.
    initial begin
        $monitor("time = %t, state = %b, in = %b, out = %b", $time, u_my_fsm_pattern.current_state, in, out);
    end

    // 3. test scenario 생성
    initial begin
        clk = 0;
        reset = 1;
        in = 0;

        // reset 해제
        #100 reset = 0;

        // test pattern 0110 10ns(1주기마다 1bit씩)
        @(posedge clk) in = 0;
        @(posedge clk) in = 1;
        @(posedge clk) in = 1;
        @(posedge clk) in = 0;

        // #2 1101을 입력시 S2로 가는지
        @(posedge clk) in = 1; // S4->S0(1)
        @(posedge clk) in = 1; // S0->S0(11)
        @(posedge clk) in = 0; // S0->S1(110)          
        @(posedge clk) in = 1; // S1->S2(1101)

        // #3 10
        @(posedge clk) in = 1; // S2->S3(11 011)
        @(posedge clk) in = 0; // S3->S4(11 0110)
        #100;
        $display("=== SIMULATION FINISHED ===");
        $finish;
    end
endmodule
