`timescale 1ns / 1ps

module uart_tx #(
    parameter BAUD = 9600
)(
    input clk,
    input reset,
    input [7:0] tx_data,
    input tx_start,

    output reg tx,
    output reg tx_done,
    output reg tx_busy
    );

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    localparam DEVIDER = 100_000_000 / BAUD; // 분주비

    reg [1:0] r_state;
    reg [3:0] r_bit_index;
    reg [7:0] r_data_register; 
    reg [15:0] r_baud_count;    
    reg r_baud_tick;      


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
            r_state <= IDLE;
            r_bit_index <= 0;
            r_data_register <= 0;
            tx_done <= 0;
            tx_busy <= 0;
            tx <= 1; // IDLE == HIGH
        end
        else begin
            if(r_state == IDLE ) begin
                tx_done <= 0;

                if(tx_start) begin
                    r_state <= START;
                    tx_busy <= 1'b1;
                    r_data_register <= tx_data;
                    r_bit_index <= 0;
                end
            end
            else if(r_baud_tick) begin
                case(r_state)   
                    START: begin
                        tx <= 1'b0; // low로 당겨 start
                        r_state <= DATA;
                    end
                    DATA: begin
                        tx <= r_data_register[r_bit_index];    
                        
                        if(r_bit_index == 4'd7) begin
                            r_state <= STOP;
                        end
                        else begin
                            r_bit_index <= r_bit_index + 1;
                        end
                    end
                    STOP: begin
                        tx <= 1'b1; // high로 올려 stop
                        tx_done <= 1;
                        tx_busy <= 0;
                        r_state = IDLE;
                    end
                    default: begin
                        r_state <= IDLE;
                    end
                endcase
            end
        end
    end
    
endmodule
