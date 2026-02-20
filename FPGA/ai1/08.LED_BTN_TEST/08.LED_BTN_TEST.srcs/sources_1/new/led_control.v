`timescale 1ns / 1ps

module led_control(
    // 입력
    input tick,
    input reset,
    input [2:0] mode,

    //출력
    output [15:0] led
    );

    parameter LINEAR_FORWARD = 3'b000;
    parameter LINEAR_BACKWARD  = 3'b001;
    parameter SYMMETRICAL_FORWARD = 3'b010; 
    parameter SYMMETRICAL_BACKWARD = 3'b011;

    reg [15:0] r_led = 16'd0;
    reg r_mode_flag = 0;

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            r_led <= 16'd0;
            r_mode_flag <= 0;
        end else begin
            
            if (r_mode_flag != mode[1]) begin
                r_mode_flag <= mode[1];
                
                if (mode == LINEAR_FORWARD) 
                    r_led <= 16'h8000; 
                else if (mode == SYMMETRICAL_FORWARD) 
                    r_led <= 16'h0180;
            end else begin
                case(mode)

                    LINEAR_FORWARD, LINEAR_BACKWARD: begin
                    
                        if(r_led == 16'd0) begin
                            r_led[(mode == LINEAR_FORWARD) ? 15 : 0] <= 1'b1;
                        end else begin
                            r_led <= (mode == LINEAR_FORWARD) ? r_led >> 1 : r_led << 1;
                        end

                    end

                    SYMMETRICAL_FORWARD, SYMMETRICAL_BACKWARD: begin

                        if((mode == SYMMETRICAL_FORWARD && r_led == 16'hFFFF) || 
                        (mode == SYMMETRICAL_BACKWARD && r_led == 16'h0180) || 
                        r_led == 16'h0000) begin
                            
                            r_led <= (mode == SYMMETRICAL_FORWARD) ? 16'h0180 : 16'hFFFF;
                            
                        end else begin
                            r_led[15:8] <= (mode == SYMMETRICAL_FORWARD) ? {r_led[14:8], 1'b1} : {1'b0, r_led[15:9]};
                            r_led[7:0]  <= (mode == SYMMETRICAL_FORWARD) ? {1'b1, r_led[7:1]}  : {r_led[6:0], 1'b0};
                        end
                        
                    end

                    default: begin
                        r_led <= 16'd0;
                    end

                endcase
                r_mode_flag <= mode[1];
            end
        end
    end

    assign led = r_led;
endmodule
