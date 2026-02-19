`timescale 1ns / 1ps

module tick_gen(
    input clk,
    input reset,
    output led
    );

    reg [25:0] r_counter; // [$clog2(50_000_000-1):0]
    reg r_led;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            r_counter <= 0;
            r_led <= 0;
        end else if(r_counter == 26'd50_000_000 - 1) begin // 500ms check // >=
            r_counter <= 0;
            r_led <= ~r_led;
        end else begin
            r_counter <= r_counter + 1;
        end
    end

    assign led = r_led;
endmodule
