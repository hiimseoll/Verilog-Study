`timescale 1ns / 1ps

module my_btn_debounce(
    input btnC,
    input clk,
    input reset,
    output [1:0] led
    );

    reg [19:0] counter = 20'd0;
    reg clean_btn = 1'b0;

    led_toggle u_led_toggle(
        .btn_debounce(clean_btn),
        .led(led)
    );

    always @(posedge clk) begin

        if(reset) begin
            counter <= 20'd0;
            clean_btn <= 1'b0;
        end
        
        if(btnC != clean_btn || counter) begin
            if(counter >= 20'd999_999) begin 
                if(btnC != clean_btn) begin
                    clean_btn <= ~clean_btn;
                    counter <= 20'd0;
                end
                else begin
                    counter <= 20'd0;
                end
            end
            else if(!counter) begin
                counter <= 20'b1;
            end
            else begin
                counter <= counter + 20'b1;           
            end
        end
    end
endmodule
