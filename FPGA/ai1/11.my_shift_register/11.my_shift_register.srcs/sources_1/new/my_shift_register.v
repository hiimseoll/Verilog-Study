`timescale 1ns / 1ps

module my_shift_register(
    input clk,
    input reset,        // sw15
    input btnU,         // 1
    input btnD,         // 0
    output [7:0] led
    );

    reg [6:0] sr7;

    wire w_posedge_btnU;
    wire w_posedge_btnD;
    wire w_clean_btnU;
    wire w_clean_btnD;


    debouncer u_debouncer1(
        .clk(clk),
        .reset(reset),
        .btn(btnU),
        .clean_btn(w_clean_btnU)
    );

    debouncer u_debouncer2(
        .clk(clk),
        .reset(reset),
        .btn(btnD),
        .clean_btn(w_clean_btnD)
    );

    pos_pulse u_pos_pulse(
        .clk(clk),
        .reset(reset),
        .clean_btnU(w_clean_btnU),
        .clean_btnD(w_clean_btnD),
        .pulse_btnU(w_posedge_btnU),
        .pulse_btnD(w_posedge_btnD)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sr7 <= 7'b0000000;
        end
        else begin
            if(w_posedge_btnU) begin
                sr7 <= {sr7[5:0], 1'b1};
            end
            else if(w_posedge_btnD) begin
                sr7 <= {sr7[5:0], 1'b0};
            end
        end
    end

    assign led = {sr7, (sr7 == 7'b1010111)};
endmodule

module pos_pulse(
    input clk,
    input reset,
    input clean_btnU,
    input clean_btnD,
    output pulse_btnU,
    output pulse_btnD
);
    reg [1:0] r_btn_reg;


    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_btn_reg <= 2'b00;
        end else begin
            r_btn_reg[0] <= clean_btnU;
            r_btn_reg[1] <= clean_btnD;
        end
    end

    assign pulse_btnU = (clean_btnU && !r_btn_reg[0]);
    assign pulse_btnD = (clean_btnD && !r_btn_reg[1]);
endmodule