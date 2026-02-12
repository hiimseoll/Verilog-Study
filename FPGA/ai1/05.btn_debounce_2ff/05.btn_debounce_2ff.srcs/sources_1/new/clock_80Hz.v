`timescale 1ns / 1ps

module clock_80Hz(
    input wire i_clk,    // input 100MHz
    input wire i_reset,  // reset sw
    output reg o_clk    // 80Hz -> 1/80 -> 0.0125 -> 12.5ms
    ); 

    //reg[23:0] r_counter = 0; // 1_250_000 : 10ns * 1_250_000 = 12.5ms
    // log2(8): 1000 : reg [3:0] r_counter
    
    reg [$clog2(1250000) -1:0] r_counter = 0; 
    // 1250000 저장할 수 있는 size를 계산해준다.


    // 10ns의 clk가 오거나  i_reset 버튼을 누르면 항상 수행.
    always @(posedge i_clk, posedge i_reset) begin
        if(i_reset) begin   // 비동기 reset 0 -> 1
            r_counter <= 0;
            o_clk <= 0;
        end else begin
            if (r_counter == (1_250_000/2)-1) begin // 0부터 시작이니까 -1
                r_counter <= 0;  // 초기화
                o_clk <= ~o_clk; // 반전
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end

endmodule
