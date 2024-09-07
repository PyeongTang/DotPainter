`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/28 18:23:32
// Design Name: 
// Module Name: tb_OLEDrgb_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_OLEDrgb_driver();

// System
reg                 i_clk           =   1'b0;
reg                 i_n_reset       =   1'b1;

// PS AXI
reg                 i_start         =   1'b0;
reg                 i_cmd_reset     =   1'b0;
reg     [3 : 0]     i_num_cmd       =   4'h0;

reg     [7 : 0]     i_cmd_1         =   8'h00;
reg     [7 : 0]     i_cmd_2         =   8'h00;
reg     [7 : 0]     i_cmd_3         =   8'h00;

reg     [7 : 0]     i_cmd_4         =   8'h00;
reg     [7 : 0]     i_cmd_5         =   8'h00;
reg     [7 : 0]     i_cmd_6         =   8'h00;

reg     [7 : 0]     i_cmd_7         =   8'h00;
reg     [7 : 0]     i_cmd_8         =   8'h00;
reg     [7 : 0]     i_cmd_9         =   8'h00;

reg     [7 : 0]     i_cmd_10         =   8'h00;
reg     [7 : 0]     i_cmd_11         =   8'h00;
reg     [7 : 0]     i_cmd_12         =   8'h00;

reg     [7 : 0]     i_cmd_13         =   8'h00;
reg     [7 : 0]     i_cmd_14         =   8'h00;
reg     [7 : 0]     i_cmd_15         =   8'h00;

wire                o_done;

// SPI
wire                o_mosi;
wire                o_sclk;
    reg [7 : 0] cmd_inc;

    OLEDrgb_driver OLEDrgb_driver_i (
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),
        
        .i_start                    (i_start),
        .i_cmd_reset                (i_cmd_reset),
        .i_num_cmd                  (i_num_cmd),

        .i_cmd_1                    (i_cmd_1),
        .i_cmd_2                    (i_cmd_2),
        .i_cmd_3                    (i_cmd_3),
        .i_cmd_4                    (i_cmd_4),
        .i_cmd_5                    (i_cmd_5),
        .i_cmd_6                    (i_cmd_6),
        .i_cmd_7                    (i_cmd_7),
        .i_cmd_8                    (i_cmd_8),
        .i_cmd_9                    (i_cmd_9),
        .i_cmd_10                   (i_cmd_10),
        .i_cmd_11                   (i_cmd_11),
        .i_cmd_12                   (i_cmd_12),
        .i_cmd_13                   (i_cmd_13),
        .i_cmd_14                   (i_cmd_14),
        .i_cmd_15                   (i_cmd_15),

        .o_done                     (o_done),

        .o_mosi                     (o_mosi),
        .o_sclk                     (o_sclk)
    );

    always #5 i_clk = ~i_clk;

    initial begin
        cmd_inc = 8'h00;
        @(posedge i_clk)    i_n_reset = 1'b0;
        @(posedge i_clk)    i_n_reset = 1'b1;

        #1000;
        @(posedge i_clk)    i_start     =   1'b1;
                            i_num_cmd   =   4'd8;
                            i_cmd_1     =   8'h01;
                            i_cmd_2     =   8'h02;
                            i_cmd_3     =   8'h03;
                            i_cmd_4     =   8'h04;
                            i_cmd_5     =   8'h05;
                            i_cmd_6     =   8'h06;
                            i_cmd_7     =   8'h07;
                            i_cmd_8     =   8'h08;

    end

    always @(*) begin
       if (o_done) begin
            #10 $stop();
            cmd_inc = cmd_inc + 8'h1;

            #10000;
            @(posedge i_clk)    i_cmd_reset = 1'b1;
                                i_start     = 1'b0;

            @(posedge i_clk)    i_start     =   1'b1;
                                i_num_cmd   =   4'd1;
                                i_cmd_1     =   i_cmd_1 + cmd_inc;
                                i_cmd_reset =   1'b0;
       end
    end



endmodule
