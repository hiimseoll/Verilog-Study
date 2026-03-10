`timescale 1ns / 1ps

module rotary_temp_set(
    input clk,
    input reset,
    input clean_s1, 
    input clean_s2, 
    input clean_key,

    output [7:0] editing_temp,  
    output reg [7:0] confirmed_temp, 
    output reg is_editing
    );

    reg [1:0] r_previous_state;
    reg [1:0] r_current_state;
    reg [1:0] r_step;
    reg [7:0] r_counter; 

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_previous_state <= 2'b00;
            r_current_state <= 2'b00;
            r_step <= 2'b00;
            r_counter <= 8'd24;        
            confirmed_temp <= 8'd24;   
            is_editing <= 1'b0;
        end
        else begin
            r_previous_state <= r_current_state;
            r_current_state <= {clean_s1, clean_s2};

            case({r_previous_state, r_current_state})
                // (CW) - 온도 증가
                4'b0010, 4'b1011, 4'b1101, 4'b0100: begin
                    r_step <= r_step + 1;
                    if(r_step == 2'b11 && r_counter < 8'd30) begin
                        r_counter <= r_counter + 1;
                        is_editing <= 1'b1; 
                    end
                end
                
                //(CCW) - 온도 감소
                4'b0001, 4'b0111, 4'b1110, 4'b1000: begin
                    r_step <= r_step + 1;
                    if(r_step == 2'b11 && r_counter > 8'd18) begin
                        r_counter <= r_counter - 1;
                        is_editing <= 1'b1;
                    end
                end
                default: ; 
            endcase

        
            if (clean_key) begin
                if (is_editing) begin
                    confirmed_temp <= r_counter;
                    is_editing <= 1'b0;          
                end
            end
        end
    end


    assign editing_temp = r_counter;
    
endmodule