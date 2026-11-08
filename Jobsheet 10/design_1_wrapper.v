//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2026.1 (lin64) Build 6511674 Tue Jun 16 11:01:26 MDT 2026
//Date        : Sun Nov  8 21:11:44 2026
//Host        : cachyos-x8664 running 64-bit CachyOS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_100MHz,
    led_tri_o,
    reset_rtl_0);
  input clk_100MHz;
  output [15:0]led_tri_o;
  input reset_rtl_0;

  wire clk_100MHz;
  wire [15:0]led_tri_o;
  wire reset_rtl_0;

  design_1 design_1_i
       (.clk_100MHz(clk_100MHz),
        .led_tri_o(led_tri_o),
        .reset_rtl_0(reset_rtl_0));
endmodule
