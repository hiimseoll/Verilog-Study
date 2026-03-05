`timescale 1ns / 1ps

module uart_rx #(
    parameter BAUD = 9600
)(
    input clk,
    input reset,
    input rx,

    output reg [7:0] data_out,
    output reg rx_done
);

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    // 9600 * 16 = 153_600
    // 100_000_000 Hz / 153_600 = 651ns (651ns주기로 샘플링)
    localparam integer DEVIDER = 100_000_000 / (BAUD * 16);

    reg [1:0] r_state;
    reg [3:0] r_bit_index;
    reg [7:0] r_data_register; // rx 수신 저장 reg
    reg [15:0] r_baud_count; // 651ns count
    reg r_baud_tick;
    reg [3:0] r_baud_tick_count; // 16 count

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_baud_count <= 0;
            r_baud_tick <= 0;
        end
        else begin
            if(r_baud_count >= DEVIDER - 1) begin
                r_baud_count <= 0;
                r_baud_tick <= 1;
            end
            else begin
                r_baud_count <= r_baud_count + 1;
                r_baud_tick <= 0;
            end
        end
    end

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            data_out <= 8'd0;
            rx_done <= 1'b0;
            r_state <= IDLE;
            r_bit_index <= 4'd0;
            r_data_register <= 8'd0;
            r_baud_tick_count <= 4'd0;
        end
        else begin
            if(r_state == IDLE ) begin
                rx_done <= 1'b0;

                if(!rx) begin // start bit rx
                    r_state <= START;
                    r_baud_tick_count <= 4'd0;
                end
            end
            else if(r_baud_tick) begin
                r_baud_tick_count <= r_baud_tick_count + 1;

                case(r_state)   
                    START: begin
                        if(r_baud_tick_count >= 4'd7) begin
                            r_state <= DATA;
                            r_bit_index <= 4'd0;
                            r_baud_tick_count <= 4'd0;
                        end
                    end
                    DATA: begin
                        if(r_baud_tick_count >= 4'd15) begin
                            r_data_register[r_bit_index] <= rx;
                            r_baud_tick_count <= 4'd0;

                            if(r_bit_index >= 4'd7) begin
                                r_state <= STOP;
                            end
                            else begin
                                r_bit_index <= r_bit_index + 1;
                            end
                        end
                    end
                    STOP: begin
                        if(r_baud_tick_count >= 4'd15) begin
                            r_state <= IDLE;
                            data_out <= r_data_register;
                            rx_done <= 1'b1;
                        end
                    end
                    default: begin
                        r_state <= IDLE;
                    end
                endcase
            end
        end
    end
endmodule

