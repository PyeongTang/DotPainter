//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sat Aug 24 22:59:51 2024
//Host        : LeeJaePyeong-DESKTOP running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (BTN,
    CS_JSTK2,
    CS_OLEDrgb,
    DC_OLEDrgb,
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    LED,
    MISO_JSTK2,
    MOSI_JSTK2,
    MOSI_OLEDrgb,
    NC_OLEDrgb,
    PMODEN_OLEDrgb,
    RES_OLEDrgb,
    RGB_L,
    RGB_R,
    SCLK_JSTK2,
    SCLK_OLEDrgb,
    SW,
    VCCEN_OLEDrgb);
  input [3:0]BTN;
  output CS_JSTK2;
  output CS_OLEDrgb;
  output DC_OLEDrgb;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [3:0]LED;
  input MISO_JSTK2;
  output MOSI_JSTK2;
  output MOSI_OLEDrgb;
  output NC_OLEDrgb;
  output PMODEN_OLEDrgb;
  output RES_OLEDrgb;
  output [2:0]RGB_L;
  output [2:0]RGB_R;
  output SCLK_JSTK2;
  output SCLK_OLEDrgb;
  input [3:0]SW;
  output VCCEN_OLEDrgb;

  wire [3:0]BTN;
  wire CS_JSTK2;
  wire CS_OLEDrgb;
  wire DC_OLEDrgb;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [3:0]LED;
  wire MISO_JSTK2;
  wire MOSI_JSTK2;
  wire MOSI_OLEDrgb;
  wire NC_OLEDrgb;
  wire PMODEN_OLEDrgb;
  wire RES_OLEDrgb;
  wire [2:0]RGB_L;
  wire [2:0]RGB_R;
  wire SCLK_JSTK2;
  wire SCLK_OLEDrgb;
  wire [3:0]SW;
  wire VCCEN_OLEDrgb;

  design_1 design_1_i
       (.BTN(BTN),
        .CS_JSTK2(CS_JSTK2),
        .CS_OLEDrgb(CS_OLEDrgb),
        .DC_OLEDrgb(DC_OLEDrgb),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .LED(LED),
        .MISO_JSTK2(MISO_JSTK2),
        .MOSI_JSTK2(MOSI_JSTK2),
        .MOSI_OLEDrgb(MOSI_OLEDrgb),
        .NC_OLEDrgb(NC_OLEDrgb),
        .PMODEN_OLEDrgb(PMODEN_OLEDrgb),
        .RES_OLEDrgb(RES_OLEDrgb),
        .RGB_L(RGB_L),
        .RGB_R(RGB_R),
        .SCLK_JSTK2(SCLK_JSTK2),
        .SCLK_OLEDrgb(SCLK_OLEDrgb),
        .SW(SW),
        .VCCEN_OLEDrgb(VCCEN_OLEDrgb));
endmodule
