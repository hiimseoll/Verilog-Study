`timescale 1ns / 1ps

module DS1302(
    input clk,
    input reset,
    input req_set,
    input req_read,
    inout data_io,

    output reg ce,
    output reg sclk,
    output reg [7:0] sec,
    output reg [7:0] min,
    output reg [7:0] hour
    );

    localparam IDLE = 2'b00;
    localparam COMMAND = 2'b01;
    localparam READ = 2'b10;
    localparam WRITE = 2'b11;
    reg [1:0] r_mode = IDLE;


    localparam READ_SEC = 8'h81;
    localparam READ_MIN = 8'h83;
    localparam READ_HOUR = 8'h85;

    localparam RTC_WRITE_BEGIN = 8'h80;
    localparam RTC_WRITE_END = 8'h84;

    reg [7:0] read_commands [0:2];
    initial begin
        read_commands[0] = READ_SEC;
        read_commands[1] = READ_MIN;
        read_commands[2] = READ_HOUR;
    end


    localparam COUNT_2MHz = 50;
    reg [$clog2(COUNT_2MHz) - 1 : 0] r_50_counter;

    reg [3:0] r_bit_counter;

    reg r_write_en;
    reg r_write_data;
    reg r_read_data;


    reg tick_2MHz;


    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_50_counter <= 0;
            tick_2MHz <= 0;
        end
        else begin
            if(r_50_counter >= COUNT_2MHz - 1) begin
                r_50_counter <= 0;
                tick_2MHz <= ~tick_2MHz;
            end
            else begin
                r_50_counter <= r_50_counter + 1;
            end
        end
    end

    always @(posedge tick_2MHz, posedge reset) begin
        if(reset) begin
            r_mode <= IDLE;
            r_write_data <= 0;
            r_read_data <= 0;
            r_bit_counter <= 0;
            r_write_en <= 0;
        end
        else begin
            case(r_mode)
                IDLE: begin
                    if(req_read || req_set) begin
                        r_mode <= COMMAND;
                        ce <= 1'b1;
                    end
                end
                COMMAND: begin
                    if(!sclk && r_bit_counter <= ) begin
                        sclk <= 1'b1;
                        r_write_en <= 1'b1;
                        r_write_data <= read_commands[3];
                    end
                    else if(!(r_bit_counter / 7))begin
                        r_bit_counter <= r_bit_counter + 1;
                        sclk <= 1'b0;
                    end

                    if(sclk && (r_bit_counter / 7)) begin
                        
                    end
                end
            endcase
        end
    end

    assign data_io = r_write_en ? r_write_data : 1'bz;
endmodule
