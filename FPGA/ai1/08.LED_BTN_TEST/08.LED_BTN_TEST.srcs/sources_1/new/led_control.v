`timescale 1ns / 1ps

module led_control(
    // 입력
    input tick,
    input reset,
    input [2:0] mode,

    //출력
    output [15:0] led
    );

    parameter IDLE = 3'b111;    // Power On/RESET
    parameter LIN_A = 3'b000;   // 직선형 ->
    parameter LIN_B  = 3'b001;  // 직선형 <-
    parameter SYM_A = 3'b010;   // 대칭형 <- x ->
    parameter SYM_B = 3'b011;   // 대칭형 -> x <-

    reg [15:0] r_led = 16'd0;
    reg [2:0] r_prev_mode = IDLE;

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            r_led <= 16'd0;
            r_prev_mode <= IDLE;
        end else begin
            
            if (r_prev_mode != mode) begin

                r_prev_mode <= mode;

                case(mode)

                    LIN_A: begin
                        r_led <= 16'h8000;  // b1000 0000 0000 0000
                    end

                    LIN_B: begin
                        r_led <= 16'h1;     // b0000 0000 0000 0001
                    end

                    SYM_A: begin
                        r_led <= 16'h0;   // b0000 0000 0000 0000
                    end

                    SYM_B: begin
                        r_led <= 16'hFFFF;  // b1111 1111 1111 1111
                    end

                    default: begin
                        r_led <= 16'd0;     // b0000 0000 0000 0000
                    end

                endcase
            end else begin

                case(mode)

                    LIN_A: begin
                        if(r_led == 16'h1) begin
                            r_led <= 16'h8000;
                        end else begin
                            r_led <= r_led >> 1;
                        end
                    end

                    LIN_B: begin
                        if(r_led == 16'h8000) begin
                            r_led <= 16'h1;
                        end else begin
                            r_led <= r_led << 1;
                        end
                    end

                    SYM_A: begin
                        if(r_led == 16'hFFFF) begin
                            r_led <= 16'h0;
                        end else begin
                            r_led <= {r_led[14:8], 1'b1, 1'b1, r_led[7:1]};
                        end
                    end

                    SYM_B: begin
                        if(r_led == 16'h0) begin
                            r_led <= 16'hFFFF;
                        end else begin
                            r_led <= {1'b0, r_led[15:9], r_led[6:0], 1'b0};
                        end
                    end

                    default: begin
                        r_led <= 16'd0;
                    end
                endcase
            end
        end
    end

    assign led = r_led;
endmodule
