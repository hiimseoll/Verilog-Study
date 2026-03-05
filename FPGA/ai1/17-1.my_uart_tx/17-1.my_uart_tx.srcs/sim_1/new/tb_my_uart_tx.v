`timescale 1ns / 1ps

module tb_my_uart_tx();

    reg clk;
    reg reset;
    reg btnL;
    reg RsRx;
    reg [7:0] sw;
    
    wire RsTx;

    top #(
        .BAUD_MODIFY(10_000_000), 
        .DEBOUNCE_LIMIT_MODIFY(10)
    ) u_top(
        .clk(clk),
        .reset(reset),
        .btnL(btnL),
        .RsRx(RsRx),
        .RsTx(RsTx),
        .sw(sw)
    );

    task btn_press();
        begin
            repeat(3) begin
                btnL = ~btnL;
                #50;
            end
            #100;
            btnL = 0;
        end
    endtask

    task set_sw_data(input integer index); // set name
        begin
            case(index)
                0: begin
                    sw = 8'b01010011; // S
                end
                1: begin
                    sw = 8'b01000100; // D
                end
                default : begin
                    sw = 8'b01001000; // H
                end
            endcase
            #50;
        end
    endtask

    // 100Mhz clock gen
    always #5 clk = ~clk;

    initial begin
        // reset
        clk = 0;
        reset = 1;
        btnL = 0;
        RsRx = 0;
        sw = 8'd0;
        #100;
        reset = 0;
        #100;

        $display("UART test start.");

        set_sw_data(0); // set 'S' as data
        btn_press();    // press btnL
        #3000;

        set_sw_data(1); // set 'D' as data
        btn_press();    // press btnL
        #3000;

        set_sw_data(2); // set 'H' as data
        btn_press();    // press btnL
        #3000;

        $display("test complete.");
        $finish;
    end
endmodule
