// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Feb 13 08:59:38 2026
// Host        : DESKTOP-FAVD00F running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               E:/project/FPGA/ai1/05.my_btn_debounce/05.my_btn_debounce.sim/sim_1/synth/func/xsim/tb_my_btn_debounce_func_synth.v
// Design      : my_btn_debounce
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module led_toggle
   (led_OBUF,
    r_led_toggle_reg_0);
  output [0:0]led_OBUF;
  input r_led_toggle_reg_0;

  wire [0:0]led_OBUF;
  wire r_led_toggle_i_1_n_0;
  wire r_led_toggle_reg_0;

  LUT1 #(
    .INIT(2'h1)) 
    r_led_toggle_i_1
       (.I0(led_OBUF),
        .O(r_led_toggle_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    r_led_toggle_reg
       (.C(r_led_toggle_reg_0),
        .CE(1'b1),
        .D(r_led_toggle_i_1_n_0),
        .Q(led_OBUF),
        .R(1'b0));
endmodule

(* NotValidForBitStream *)
module my_btn_debounce
   (btnC,
    clk,
    reset,
    led);
  input btnC;
  input clk;
  input reset;
  output [1:0]led;

  wire btnC;
  wire btnC_IBUF;
  wire clean_btn_i_1_n_0;
  wire clean_btn_reg_n_0;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [19:1]counter0;
  wire \counter[0]_i_1_n_0 ;
  wire \counter[19]_i_10_n_0 ;
  wire \counter[19]_i_11_n_0 ;
  wire \counter[19]_i_12_n_0 ;
  wire \counter[19]_i_13_n_0 ;
  wire \counter[19]_i_14_n_0 ;
  wire \counter[19]_i_1_n_0 ;
  wire \counter[19]_i_2_n_0 ;
  wire \counter[19]_i_4_n_0 ;
  wire \counter[19]_i_5_n_0 ;
  wire \counter[19]_i_6_n_0 ;
  wire \counter[19]_i_7_n_0 ;
  wire \counter[19]_i_8_n_0 ;
  wire \counter[19]_i_9_n_0 ;
  wire \counter_reg[12]_i_1_n_0 ;
  wire \counter_reg[12]_i_1_n_1 ;
  wire \counter_reg[12]_i_1_n_2 ;
  wire \counter_reg[12]_i_1_n_3 ;
  wire \counter_reg[16]_i_1_n_0 ;
  wire \counter_reg[16]_i_1_n_1 ;
  wire \counter_reg[16]_i_1_n_2 ;
  wire \counter_reg[16]_i_1_n_3 ;
  wire \counter_reg[19]_i_3_n_2 ;
  wire \counter_reg[19]_i_3_n_3 ;
  wire \counter_reg[4]_i_1_n_0 ;
  wire \counter_reg[4]_i_1_n_1 ;
  wire \counter_reg[4]_i_1_n_2 ;
  wire \counter_reg[4]_i_1_n_3 ;
  wire \counter_reg[8]_i_1_n_0 ;
  wire \counter_reg[8]_i_1_n_1 ;
  wire \counter_reg[8]_i_1_n_2 ;
  wire \counter_reg[8]_i_1_n_3 ;
  wire \counter_reg_n_0_[0] ;
  wire \counter_reg_n_0_[10] ;
  wire \counter_reg_n_0_[11] ;
  wire \counter_reg_n_0_[12] ;
  wire \counter_reg_n_0_[13] ;
  wire \counter_reg_n_0_[14] ;
  wire \counter_reg_n_0_[15] ;
  wire \counter_reg_n_0_[16] ;
  wire \counter_reg_n_0_[17] ;
  wire \counter_reg_n_0_[18] ;
  wire \counter_reg_n_0_[19] ;
  wire \counter_reg_n_0_[1] ;
  wire \counter_reg_n_0_[2] ;
  wire \counter_reg_n_0_[3] ;
  wire \counter_reg_n_0_[4] ;
  wire \counter_reg_n_0_[5] ;
  wire \counter_reg_n_0_[6] ;
  wire \counter_reg_n_0_[7] ;
  wire \counter_reg_n_0_[8] ;
  wire \counter_reg_n_0_[9] ;
  wire [1:0]led;
  wire [0:0]led_OBUF;
  wire reset;
  wire reset_IBUF;
  wire [3:2]\NLW_counter_reg[19]_i_3_CO_UNCONNECTED ;
  wire [3:3]\NLW_counter_reg[19]_i_3_O_UNCONNECTED ;

  IBUF btnC_IBUF_inst
       (.I(btnC),
        .O(btnC_IBUF));
  LUT6 #(
    .INIT(64'h4444444470707044)) 
    clean_btn_i_1
       (.I0(reset_IBUF),
        .I1(clean_btn_reg_n_0),
        .I2(btnC_IBUF),
        .I3(\counter[19]_i_5_n_0 ),
        .I4(\counter_reg_n_0_[15] ),
        .I5(\counter[19]_i_6_n_0 ),
        .O(clean_btn_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    clean_btn_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(clean_btn_i_1_n_0),
        .Q(clean_btn_reg_n_0),
        .R(1'b0));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT6 #(
    .INIT(64'h4600460046004646)) 
    \counter[0]_i_1 
       (.I0(\counter_reg_n_0_[0] ),
        .I1(\counter[19]_i_2_n_0 ),
        .I2(reset_IBUF),
        .I3(\counter[19]_i_6_n_0 ),
        .I4(\counter_reg_n_0_[15] ),
        .I5(\counter[19]_i_5_n_0 ),
        .O(\counter[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hE0E0E0E0EEEEEEE0)) 
    \counter[19]_i_1 
       (.I0(\counter[19]_i_2_n_0 ),
        .I1(reset_IBUF),
        .I2(\counter[19]_i_4_n_0 ),
        .I3(\counter[19]_i_5_n_0 ),
        .I4(\counter_reg_n_0_[15] ),
        .I5(\counter[19]_i_6_n_0 ),
        .O(\counter[19]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \counter[19]_i_10 
       (.I0(\counter_reg_n_0_[9] ),
        .I1(\counter_reg_n_0_[3] ),
        .I2(\counter_reg_n_0_[5] ),
        .I3(\counter_reg_n_0_[19] ),
        .O(\counter[19]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \counter[19]_i_11 
       (.I0(\counter_reg_n_0_[15] ),
        .I1(\counter_reg_n_0_[1] ),
        .I2(\counter_reg_n_0_[14] ),
        .I3(\counter_reg_n_0_[8] ),
        .O(\counter[19]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \counter[19]_i_12 
       (.I0(\counter_reg_n_0_[7] ),
        .I1(\counter_reg_n_0_[6] ),
        .I2(\counter_reg_n_0_[0] ),
        .I3(\counter_reg_n_0_[17] ),
        .O(\counter[19]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \counter[19]_i_13 
       (.I0(\counter_reg_n_0_[6] ),
        .I1(\counter_reg_n_0_[7] ),
        .O(\counter[19]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \counter[19]_i_14 
       (.I0(\counter_reg_n_0_[2] ),
        .I1(\counter_reg_n_0_[5] ),
        .I2(\counter_reg_n_0_[1] ),
        .I3(\counter_reg_n_0_[3] ),
        .I4(\counter_reg_n_0_[0] ),
        .I5(\counter_reg_n_0_[4] ),
        .O(\counter[19]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFEFFFF)) 
    \counter[19]_i_2 
       (.I0(\counter[19]_i_7_n_0 ),
        .I1(\counter[19]_i_8_n_0 ),
        .I2(\counter[19]_i_9_n_0 ),
        .I3(\counter[19]_i_10_n_0 ),
        .I4(\counter[19]_i_11_n_0 ),
        .I5(\counter[19]_i_12_n_0 ),
        .O(\counter[19]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    \counter[19]_i_4 
       (.I0(\counter[19]_i_12_n_0 ),
        .I1(\counter[19]_i_11_n_0 ),
        .I2(\counter[19]_i_10_n_0 ),
        .I3(\counter[19]_i_9_n_0 ),
        .I4(\counter[19]_i_8_n_0 ),
        .O(\counter[19]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAA8AAAA88888888)) 
    \counter[19]_i_5 
       (.I0(\counter_reg_n_0_[14] ),
        .I1(\counter[19]_i_8_n_0 ),
        .I2(\counter_reg_n_0_[8] ),
        .I3(\counter[19]_i_13_n_0 ),
        .I4(\counter[19]_i_14_n_0 ),
        .I5(\counter_reg_n_0_[9] ),
        .O(\counter[19]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \counter[19]_i_6 
       (.I0(\counter_reg_n_0_[16] ),
        .I1(\counter_reg_n_0_[19] ),
        .I2(\counter_reg_n_0_[17] ),
        .I3(\counter_reg_n_0_[18] ),
        .O(\counter[19]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \counter[19]_i_7 
       (.I0(clean_btn_reg_n_0),
        .I1(btnC_IBUF),
        .O(\counter[19]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \counter[19]_i_8 
       (.I0(\counter_reg_n_0_[11] ),
        .I1(\counter_reg_n_0_[13] ),
        .I2(\counter_reg_n_0_[12] ),
        .I3(\counter_reg_n_0_[10] ),
        .O(\counter[19]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \counter[19]_i_9 
       (.I0(\counter_reg_n_0_[2] ),
        .I1(\counter_reg_n_0_[16] ),
        .I2(\counter_reg_n_0_[4] ),
        .I3(\counter_reg_n_0_[18] ),
        .O(\counter[19]_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter[0]_i_1_n_0 ),
        .Q(\counter_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[10]),
        .Q(\counter_reg_n_0_[10] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[11]),
        .Q(\counter_reg_n_0_[11] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[12]),
        .Q(\counter_reg_n_0_[12] ),
        .R(\counter[19]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \counter_reg[12]_i_1 
       (.CI(\counter_reg[8]_i_1_n_0 ),
        .CO({\counter_reg[12]_i_1_n_0 ,\counter_reg[12]_i_1_n_1 ,\counter_reg[12]_i_1_n_2 ,\counter_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(counter0[12:9]),
        .S({\counter_reg_n_0_[12] ,\counter_reg_n_0_[11] ,\counter_reg_n_0_[10] ,\counter_reg_n_0_[9] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[13]),
        .Q(\counter_reg_n_0_[13] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[14]),
        .Q(\counter_reg_n_0_[14] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[15]),
        .Q(\counter_reg_n_0_[15] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[16]),
        .Q(\counter_reg_n_0_[16] ),
        .R(\counter[19]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \counter_reg[16]_i_1 
       (.CI(\counter_reg[12]_i_1_n_0 ),
        .CO({\counter_reg[16]_i_1_n_0 ,\counter_reg[16]_i_1_n_1 ,\counter_reg[16]_i_1_n_2 ,\counter_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(counter0[16:13]),
        .S({\counter_reg_n_0_[16] ,\counter_reg_n_0_[15] ,\counter_reg_n_0_[14] ,\counter_reg_n_0_[13] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[17]),
        .Q(\counter_reg_n_0_[17] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[18]),
        .Q(\counter_reg_n_0_[18] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[19]),
        .Q(\counter_reg_n_0_[19] ),
        .R(\counter[19]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \counter_reg[19]_i_3 
       (.CI(\counter_reg[16]_i_1_n_0 ),
        .CO({\NLW_counter_reg[19]_i_3_CO_UNCONNECTED [3:2],\counter_reg[19]_i_3_n_2 ,\counter_reg[19]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_counter_reg[19]_i_3_O_UNCONNECTED [3],counter0[19:17]}),
        .S({1'b0,\counter_reg_n_0_[19] ,\counter_reg_n_0_[18] ,\counter_reg_n_0_[17] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[1]),
        .Q(\counter_reg_n_0_[1] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[2]),
        .Q(\counter_reg_n_0_[2] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[3]),
        .Q(\counter_reg_n_0_[3] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[4]),
        .Q(\counter_reg_n_0_[4] ),
        .R(\counter[19]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \counter_reg[4]_i_1 
       (.CI(1'b0),
        .CO({\counter_reg[4]_i_1_n_0 ,\counter_reg[4]_i_1_n_1 ,\counter_reg[4]_i_1_n_2 ,\counter_reg[4]_i_1_n_3 }),
        .CYINIT(\counter_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(counter0[4:1]),
        .S({\counter_reg_n_0_[4] ,\counter_reg_n_0_[3] ,\counter_reg_n_0_[2] ,\counter_reg_n_0_[1] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[5]),
        .Q(\counter_reg_n_0_[5] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[6]),
        .Q(\counter_reg_n_0_[6] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[7]),
        .Q(\counter_reg_n_0_[7] ),
        .R(\counter[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[8]),
        .Q(\counter_reg_n_0_[8] ),
        .R(\counter[19]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \counter_reg[8]_i_1 
       (.CI(\counter_reg[4]_i_1_n_0 ),
        .CO({\counter_reg[8]_i_1_n_0 ,\counter_reg[8]_i_1_n_1 ,\counter_reg[8]_i_1_n_2 ,\counter_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(counter0[8:5]),
        .S({\counter_reg_n_0_[8] ,\counter_reg_n_0_[7] ,\counter_reg_n_0_[6] ,\counter_reg_n_0_[5] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\counter[19]_i_2_n_0 ),
        .D(counter0[9]),
        .Q(\counter_reg_n_0_[9] ),
        .R(\counter[19]_i_1_n_0 ));
  OBUF \led_OBUF[0]_inst 
       (.I(led_OBUF),
        .O(led[0]));
  OBUFT \led_OBUF[1]_inst 
       (.I(1'b0),
        .O(led[1]),
        .T(1'b1));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  led_toggle u_led_toggle
       (.led_OBUF(led_OBUF),
        .r_led_toggle_reg_0(clean_btn_reg_n_0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
