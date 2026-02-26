`timescale 1ns / 1ps

module my_fsm_pattern(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
    );

    // 상태 정의
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, 
                S3 = 3'b011, S4 = 3'b100;

    reg [2:0] current_state = S0;
    reg [2:0] next_state;

    // next state logic
    always @(*) begin
        case(current_state)
        S0: next_state = in ? S0 : S1;
        S1: next_state = in ? S2 : S1;
        S2: next_state = in ? S3 : S1;
        S3: next_state = in ? S0 : S4;
        S3: next_state = in ? S0 : S1;
        default: next_state = S0;
        endcase
    end

    // current state register
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            current_state <= S0;
        end
        else begin
            current_state <= next_state;
        end
    end

    // output logic
    always @(*) begin
        out = 1'b0; // 기본값 설정: latch 방지 위해

        case(current_state)
        S3: begin
            out = (in == 1'b0);
        end 
        default: begin
            out = 1'b0;
        end
        endcase
    end
endmodule
