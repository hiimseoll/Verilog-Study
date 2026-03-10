`timescale 1ns / 1ps

module DS1302(
    input clk,
    input reset,
    input req_set,
    input req_read,
    input [13:0] in_time,
    output [13:0] out_time,
    inout data_io,
    output reg ce,
    output reg sclk
);

wire [6:0] in_hour_bin = in_time / 100;
    wire [6:0] in_min_bin    = in_time % 100;

    wire [7:0] in_hour_bcd = ((in_hour_bin / 10) << 4) | (in_hour_bin % 10);
    wire [7:0] in_min_bcd    = ((in_min_bin / 10) << 4)    | (in_min_bin % 10);

    reg [7:0] r_min_bcd;
    reg [7:0] r_hour_bcd;

    wire [6:0] out_hour_bin = (r_hour_bcd[7:4] * 10) + r_hour_bcd[3:0];
    wire [6:0] out_min_bin    = (r_min_bcd[7:4] * 10)    + r_min_bcd[3:0];

    assign out_time = (out_hour_bin * 100) + out_min_bin;

    localparam IDLE         = 3'b000;
    localparam COMMAND    = 3'b001;
    localparam READ         = 3'b010;
    localparam WRITE        = 3'b011;
    localparam NEXT_REG = 3'b100;
    localparam DELAY        = 3'b101;

    reg [2:0] r_mode = IDLE;
    reg [1:0] r_reg_index;
    reg r_is_write;

    localparam READ_MIN    = 8'h83;
    localparam READ_HOUR = 8'h85;
    localparam WRITE_WP    = 8'h8E;
    localparam WRITE_SEC = 8'h80;
    localparam WRITE_MIN = 8'h82;
    localparam WRITE_HOUR= 8'h84;

    reg [7:0] read_commands [0:1];
    reg [7:0] write_commands [0:3];

    initial begin
        read_commands[0]    = READ_MIN;
        read_commands[1]    = READ_HOUR;
        write_commands[0] = WRITE_WP;
        write_commands[1] = WRITE_SEC;
        write_commands[2] = WRITE_MIN;
        write_commands[3] = WRITE_HOUR;
    end

    localparam COUNT_2MHz = 50;
    reg [$clog2(COUNT_2MHz) - 1 : 0] r_50_counter;
    wire tick_en = (r_50_counter == COUNT_2MHz - 1);

    reg r_flag_set;
    reg r_flag_read;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_50_counter <= 0;
            r_flag_set <= 0; 
            r_flag_read <= 0;
        end else begin
            if(tick_en) r_50_counter <= 0;
            else r_50_counter <= r_50_counter + 1;

            if(req_set) r_flag_set <= 1;
            if(req_read) r_flag_read <= 1;

            if(tick_en && r_mode == IDLE) begin
                if(r_flag_read || r_flag_set) begin
                    r_flag_read <= 0; 
                    r_flag_set <= 0;
                end
            end
        end
    end

    reg [3:0] r_bit_counter;
    reg r_write_en;
    reg r_write_data;
    reg [7:0] r_data_rx;
    reg [7:0] r_data_tx;
    reg [7:0] r_cmd;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_mode <= IDLE;
            ce <= 0; sclk <= 0;
            r_write_data <= 0; r_write_en <= 0;
            r_bit_counter <= 0; r_reg_index <= 0;
            r_min_bcd <= 0; r_hour_bcd <= 0;
            r_is_write <= 0;
        end else if(tick_en) begin
            case(r_mode)
                IDLE: begin
                    ce <= 0; sclk <= 0;
                    r_bit_counter <= 0; r_reg_index <= 0; r_write_en <= 0;

                    if(r_flag_read) begin
                        r_mode <= COMMAND;
                        r_is_write <= 0;
                        ce <= 1; r_write_en <= 1;
                        r_cmd <= read_commands[0];
                        r_write_data <= read_commands[0][0];
                    end else if(r_flag_set) begin
                        r_mode <= COMMAND;
                        r_is_write <= 1;
                        ce <= 1; r_write_en <= 1;
                        r_cmd <= write_commands[0];
                        r_write_data <= write_commands[0][0];
                        r_data_tx <= 8'h00;
                    end
                end

                COMMAND: begin
                    if(!sclk) begin
                        sclk <= 1; 
                    end else begin
                        sclk <= 0; 
                        if(r_bit_counter == 7) begin
                            r_bit_counter <= 0;
                            r_mode <= r_is_write ? WRITE : READ;
                            if(!r_is_write) r_write_en <= 0; 
                            else r_write_data <= r_data_tx[0];
                        end else begin
                            r_bit_counter <= r_bit_counter + 1;
                            r_write_data <= r_cmd[r_bit_counter + 1];
                        end
                    end
                end

                READ: begin
                    if(!sclk) begin
                        r_data_rx[r_bit_counter] <= data_io; 
                        sclk <= 1;
                    end else begin
                        sclk <= 0;
                        if(r_bit_counter == 7) begin
                            r_bit_counter <= 0;
                            r_mode <= NEXT_REG;
                        end else begin
                            r_bit_counter <= r_bit_counter + 1;
                        end
                    end
                end

                WRITE: begin
                    if(!sclk) begin
                        sclk <= 1;
                    end else begin
                        sclk <= 0;
                        if(r_bit_counter == 7) begin
                            r_bit_counter <= 0;
                            r_mode <= NEXT_REG;
                        end else begin
                            r_bit_counter <= r_bit_counter + 1;
                            r_write_data <= r_data_tx[r_bit_counter + 1];
                        end
                    end
                end

                NEXT_REG: begin
                    ce <= 0; r_write_en <= 0;
                    if(!r_is_write) begin
                        if(r_reg_index == 0) r_min_bcd <= r_data_rx;
                        else r_hour_bcd <= r_data_rx;

                        if(r_reg_index == 1) r_mode <= IDLE; 
                        else begin
                            r_reg_index <= r_reg_index + 1; 
                            r_mode <= DELAY;
                        end
                    end else begin
                        if(r_reg_index == 3) r_mode <= IDLE; 
                        else begin
                            r_reg_index <= r_reg_index + 1; 
                            r_mode <= DELAY;
                        end
                    end
                end

                DELAY: begin
                    ce <= 1; r_write_en <= 1;
                    r_mode <= COMMAND;
                if(!r_is_write) begin
                        r_cmd <= read_commands[r_reg_index];
                        r_write_data <= read_commands[r_reg_index][0];
                    end else begin
                        r_cmd <= write_commands[r_reg_index];
                        r_write_data <= write_commands[r_reg_index][0];
                        
                        if(r_reg_index == 1) r_data_tx <= 8'h00;
                        else if(r_reg_index == 2) r_data_tx <= in_min_bcd;
                        else if(r_reg_index == 3) r_data_tx <= in_hour_bcd;
                    end
                end
            endcase
        end
    end

    assign data_io = r_write_en ? r_write_data : 1'bz;
endmodule