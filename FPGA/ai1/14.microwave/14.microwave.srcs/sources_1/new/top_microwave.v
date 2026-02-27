`timescale 1ns / 1ps

module top_microwave(
    input clk,
    input reset,
    input [4:0] btn,

    output buzzer,
    output [7:0] seg,
    output [3:0] an,
    output dir_plate,
    output pwm_plate,
    output pwm_door
    );

    localparam NONE = 3'b000;
    localparam OPEN_CLOSE = 3'b001;
    localparam START_STOP = 3'b010;
    localparam ADD_TIME = 3'b011;
    localparam ADD_SPEED = 3'b100;
    localparam CANCEL = 3'b101;

    wire [4:0] w_btn;

    reg r_melody_mode;
    reg r_action;

    debouncer u_btn0_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn[0]),
        .clean_btn(w_btn[0])
    );

    debouncer u_btn1_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn[1]),
        .clean_btn(w_btn[1])
    );

    debouncer u_btn2_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn[2]),
        .clean_btn(w_btn[2])
    );

    debouncer u_btn3_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn[3]),
        .clean_btn(w_btn[3])
    );

    debouncer u_btn4_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn[4]),
        .clean_btn(w_btn[4])
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_melody_mode <= 0;
        end
        else begin
            case(w_btn)
            5'b00000: begin
                r_action <= OPEN_CLOSE;
            end
            5'b00010: begin
                r_action <= START_STOP;
            end
            5'b00100: begin
                r_action <= ADD_TIME;
            end
            5'b01000: begin
                r_action <= ADD_SPEED;
            end
            5'b10000: begin
                r_action <= CANCEL;
            end
            default: begin
                r_action <= NONE;
            end
            endcase
        end
    end

    always @(r_action) begin
        case(r_action)

        ADD_TIME: begin
        end

        endcase
    end
endmodule
