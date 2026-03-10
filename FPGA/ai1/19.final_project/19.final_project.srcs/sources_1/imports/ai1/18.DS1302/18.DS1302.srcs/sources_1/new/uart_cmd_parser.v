`timescale 1ns / 1ps

module uart_cmd_parser(
    input wire clk,
    input wire reset,
    input wire rx_valid,
    input wire [7:0] in_data, 
    
    output reg req_set_time,  // set time pulse
    output reg req_set_alarm, // set alarm pulse
    output reg [13:0] parsed_time // ex: 14'd1229
    );

    localparam IDLE  = 4'd0;
    localparam S_S   = 4'd1;
    localparam S_E   = 4'd2;
    localparam S_T   = 4'd3;
    localparam S_CMD = 4'd4;
    localparam S_D1  = 4'd5;
    localparam S_D2  = 4'd6;
    localparam S_D3  = 4'd7;
    localparam S_D4  = 4'd8;

    reg [3:0] state;
    reg is_alarm; // setA or setT
    reg [13:0] temp_time; 

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            req_set_time <= 0;
            req_set_alarm <= 0;
            parsed_time <= 0;
            temp_time <= 0;
            is_alarm <= 0;
        end 
        else begin
            
            req_set_time <= 0;
            req_set_alarm <= 0;

            if (rx_valid) begin
                case(state)
                    IDLE: begin
                        if(in_data == "s") begin
                            state <= S_S;
                        end
                    end
                    S_S: begin
                        if(in_data == "e") begin
                            state <= S_E; 
                        end
                        else if(in_data != "s") begin
                            state <= IDLE;
                        end
                    end
                    S_E: begin
                        if(in_data == "t") begin
                            state <= S_T; 
                        end
                        else if(in_data == "s") begin
                            state <= S_S;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                    S_T: begin
                        if(in_data == "A") begin
                            state <= S_CMD; is_alarm <= 1;
                        end
                        else if(in_data == "T") begin
                            state <= S_CMD;
                            is_alarm <= 0;
                        end
                        else if(in_data == "s") begin
                            state <= S_S;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                    S_CMD: begin
                        if(in_data >= "0" && in_data <= "9") begin
                            temp_time <= (in_data - "0"); // digit1
                            state <= S_D2;
                        end else state <= IDLE;
                    end
                    S_D2: begin
                        if(in_data >= "0" && in_data <= "9") begin
                            temp_time <= (temp_time * 10) + (in_data - "0"); // digit2
                            state <= S_D3;
                        end else state <= IDLE;
                    end
                    S_D3: begin
                        if(in_data >= "0" && in_data <= "9") begin
                              temp_time <= (temp_time * 10) + (in_data - "0"); // digit3
                              state <= S_D4;
                        end else state <= IDLE;
                    end
                    S_D4: begin
                        if(in_data >= "0" && in_data <= "9") begin
                              parsed_time <= (temp_time * 10) + (in_data - "0"); // digit4
                              if(is_alarm) req_set_alarm <= 1;
                              else req_set_time <= 1;
                              state <= IDLE;
                        end else state <= IDLE;
                    end
                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule