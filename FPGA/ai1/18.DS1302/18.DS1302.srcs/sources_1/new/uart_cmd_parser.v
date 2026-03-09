`timescale 1ns / 1ps

module uart_cmd_parser(
    input wire clk,
    input wire reset,
    input wire rx_valid,      // UART 1바이트 수신 완료 펄스 (필수)
    input wire [7:0] in_data, // 수신된 8비트 ASCII 데이터
    
    output reg req_set_time,  // setT 파싱 완료 시 1클럭 펄스 발생
    output reg req_set_alarm, // setA 파싱 완료 시 1클럭 펄스 발생
    output reg [13:0] parsed_time // 10진수 변환 완료된 시간 (예: 14'd1229)
    );

    // 상태 정의
    localparam IDLE  = 4'd0;
    localparam S_S   = 4'd1;
    localparam S_E   = 4'd2;
    localparam S_T   = 4'd3;
    localparam S_CMD = 4'd4;
    localparam S_D1  = 4'd5;
    localparam S_D2  = 4'd6;
    localparam S_D3  = 4'd7;
    localparam S_D4  = 4'd8;

    reg [3:0] state;
    reg is_alarm; // 1: setA, 0: setT
    reg [13:0] temp_time; // 연산용 임시 레지스터

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            req_set_time <= 0;
            req_set_alarm <= 0;
            parsed_time <= 0;
            temp_time <= 0;
            is_alarm <= 0;
        end 
        else begin
            // 펄스 신호 초기화
            req_set_time <= 0;
            req_set_alarm <= 0;

            if (rx_valid) begin
                case(state)
                    IDLE: if(in_data == "s") state <= S_S;
                    S_S:  if(in_data == "e") state <= S_E; else if(in_data != "s") state <= IDLE;
                    S_E:  if(in_data == "t") state <= S_T; else if(in_data == "s") state <= S_S; else state <= IDLE;
                    S_T:  begin
                              if(in_data == "A") begin state <= S_CMD; is_alarm <= 1; end
                              else if(in_data == "T") begin state <= S_CMD; is_alarm <= 0; end
                              else if(in_data == "s") state <= S_S; else state <= IDLE;
                          end
                    S_CMD:if(in_data >= "0" && in_data <= "9") begin
                              temp_time <= (in_data - "0"); // 첫 번째 자리
                              state <= S_D2;
                          end else state <= IDLE;
                    S_D2: if(in_data >= "0" && in_data <= "9") begin
                              temp_time <= (temp_time * 10) + (in_data - "0"); // 두 번째 자리
                              state <= S_D3;
                          end else state <= IDLE;
                    S_D3: if(in_data >= "0" && in_data <= "9") begin
                              temp_time <= (temp_time * 10) + (in_data - "0"); // 세 번째 자리
                              state <= S_D4;
                          end else state <= IDLE;
                    S_D4: if(in_data >= "0" && in_data <= "9") begin
                              parsed_time <= (temp_time * 10) + (in_data - "0"); // 최종 저장
                              if(is_alarm) req_set_alarm <= 1;
                              else req_set_time <= 1;
                              state <= IDLE;
                          end else state <= IDLE;
                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule