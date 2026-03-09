`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input btnL,

    inout data_io,

    output ce,
    output sclk,
    output [13:0] led

);
    wire w_clean_btnL;
    reg req_read;
    reg req_set;

    DS1302 u_DS1302(
        .clk(clk),
        .reset(reset),
        .req_set(w_clean_btnL),
        .req_read(req_read),
        .in_time(14'd1229),
        .out_time(led), 
        .data_io(data_io),
        .ce(ce),
        .sclk(sclk)
    );

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btnL),
        .clean_btn(w_clean_btnL)
    );

    reg [$clog2(100_000_000) - 1 : 0] r_counter;
    

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
        end
        else begin
            if(r_counter >= 100_000_000 - 1) begin
                r_counter <= 0;
                req_read <= 1;
            end
            else begin
                req_read <= 0;
                r_counter <= r_counter + 1;
            end
        end
    end
endmodule
