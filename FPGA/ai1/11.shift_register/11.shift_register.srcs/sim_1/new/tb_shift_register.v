`timescale 1ns / 1ps

module tb_shift_register();
    //input
    reg clk;
    reg reset;
    reg in;

    //output
    wire out;

    // 1. 테스트할 모듈을 인스턴스화
    shift_register u_shift_register(
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // 2. clk을 생성 (100Mhz: 1주고 10ns (High: 5ns, Low: 5ns))
    always #5 clk = ~clk;

    // 값이 변하면 값을 출력한다.
    initial begin
        $monitor("time = %t, in = %b, out = %b", $time, in, out);
    end

    // 3. test scenario 생성
    initial begin
        clk = 0;
        reset = 1;
        in = 0;

        // reset 해제
        #100 reset = 0;

        // test pattern 1010111 10ns(1주기마다 1bit씩)
        @(posedge clk) in = 1;
        @(posedge clk) in = 0;
        @(posedge clk) in = 1;
        @(posedge clk) in = 0;
        @(posedge clk) in = 1;
        @(posedge clk) in = 1;
        // S6 -> S1 : 여기서 out == 1
        @(posedge clk) in = 1; 

        // #2 011을 입력시 S1으로 오는지
        @(posedge clk) in = 0; // S1->S2(10)
        @(posedge clk) in = 1; // S2->S3(101)
        @(posedge clk) in = 1; // S3->S1(1이 들어오면 S1으로 간다)

        // #3 010111
        @(posedge clk) in = 0; // S1->S2(10)
        @(posedge clk) in = 1; // S2->S3(101)
        @(posedge clk) in = 0; // S3->S4(1010)
        @(posedge clk) in = 1; // S4->S5(10101)
        @(posedge clk) in = 1; // S5->S6(101011)
        @(posedge clk) in = 1; // S6->S1(1010111 검출)
        #100;
        $display("=== SIMULATION FINISHED ===");
        $finish;
    end
endmodule
