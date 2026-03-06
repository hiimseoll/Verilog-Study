`timescale 1ns / 1ps

module control_tower(
    input clk,
    input reset,        // sw[15]
    input [7:0] rx_data,    // uart 8bits
    input rx_done,          // data arrival sig
    output led0
    );
    
    // mode define
    parameter LED_0_ON = 1'b1;
    parameter LED_0_OFF = 1'b0;

    parameter READ = 2'b01;
    parameter WRITE = 2'b10;
    parameter IDLE = 2'b11;

    parameter QUEUE_SIZE = 10;    

    reg [7:0] queue_data [0:QUEUE_SIZE - 1];
    reg [3:0] write_pointer;
    reg [3:0] read_pointer;
    
    reg [1:0] read_write_mode = IDLE;
    reg [7:0] r_data_for_check;

    wire [7:0] w_data_for_check;

    integer i = 0;
    // write
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            for (i = 0; i < QUEUE_SIZE; i = i + 1) begin
                queue_data[i] <= 8'd0;
            end
            write_pointer <= 4'd0;
            read_pointer <= 4'd0;
            read_write_mode <= IDLE;
        end else begin
            case(read_write_mode)
                IDLE: begin
                    if(rx_done) begin
                        read_write_mode <= WRITE;
                    end
                end
                WRITE: begin
                    queue_data[write_pointer] <= rx_data;

                    write_pointer <= (write_pointer >= 9) ? 0 : write_pointer + 1;

                    if(rx_data == 8'h0A) begin
                        read_write_mode <= READ;
                        r_data_for_check <= 8'h00;
                    end
                    else begin
                        read_write_mode <= IDLE;
                    end
                end

                READ: begin
                    r_data_for_check <= queue_data[read_pointer]; 

                    read_pointer <= (read_pointer >= 9) ? 0 : read_pointer + 1;

                    if(queue_data[read_pointer] == 8'h0A) begin
                        read_write_mode <= IDLE;
                    end
                end
                default: begin
                    read_write_mode <= IDLE;
                end
            endcase
        end
    end


    fsm_pattern u_fsm_pattern(
        .clk(clk),
        .reset(reset),
        .in(w_data_for_check),
        .out(led0)
    );

    assign w_data_for_check = r_data_for_check;
endmodule
