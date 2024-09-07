`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/28 15:36:47
// Design Name: 
// Module Name: OLEDrgb_driver
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


module OLEDrgb_driver(
        // System
        input       wire                    i_clk,
        input       wire                    i_n_reset,

        // PS AXI
        input       wire                    i_start,
        input       wire                    i_cmd_reset,
        input       wire        [3 : 0]     i_num_cmd,
        
        input       wire        [7 : 0]     i_cmd_1,
        input       wire        [7 : 0]     i_cmd_2,
        input       wire        [7 : 0]     i_cmd_3,
        input       wire        [7 : 0]     i_cmd_4,
        input       wire        [7 : 0]     i_cmd_5,
        input       wire        [7 : 0]     i_cmd_6,
        input       wire        [7 : 0]     i_cmd_7,
        input       wire        [7 : 0]     i_cmd_8,
        
        input       wire        [7 : 0]     i_cmd_9,
        input       wire        [7 : 0]     i_cmd_10,
        input       wire        [7 : 0]     i_cmd_11,
        input       wire        [7 : 0]     i_cmd_12,
        input       wire        [7 : 0]     i_cmd_13,
        input       wire        [7 : 0]     i_cmd_14,
        input       wire        [7 : 0]     i_cmd_15,

        output      wire                    o_done,

        // SPI
        output      wire                    o_mosi,
        output      wire                    o_sclk,
        output      wire                    o_cs
    );

    wire            w_sclk;
    wire            w_sclk_z;
    wire            w_sclk_zz;
    wire            w_sclk_en;

    wire            w_cmd_set;
    wire            w_cmd_set_done;
    wire            w_cmd_reset;

    wire            w_next_byte;

    wire            w_last_byte;
    wire            w_last_tx_done;

    wire [7 : 0]    w_cmd;
    wire            w_tx_done;

    wait_counter #(
        .THRESHOLD  (50),   // PER : 1us
        .MODE       (1),    // TOGGLE : clk
        .IDLE       (1)     // IDLE : H
    ) SCLK_GEN (
        .i_clk      (i_clk),
        .i_n_reset  (i_n_reset),
        .i_enable   (w_sclk_en),
        .o_tick     (w_sclk)
    );

    reg r_sclk_z;
    reg r_sclk_zz;

    always @(posedge i_clk) begin
        if (!i_n_reset) begin
            r_sclk_z <= 1'b1;
            r_sclk_zz <= 1'b1;
        end
        else begin
            r_sclk_z <= w_sclk;
            r_sclk_zz <= r_sclk_z;
        end
    end
    assign w_sclk_z     = r_sclk_z;
    assign w_sclk_zz    = r_sclk_zz;
    assign o_sclk       = w_sclk_zz;

    cmd_processor cmd_processor_i   (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // wait counter
        .i_sclk                     (w_sclk),
        .i_sclk_z                   (w_sclk_z),
        .i_sclk_zz                  (w_sclk_zz),
        
        // Control
        .i_cmd_set                  (w_cmd_set),
        .i_cmd_reset                (w_cmd_reset),
        .i_next_byte                (w_next_byte),
        .i_tx_data                  (w_cmd),
        .o_done                     (w_tx_done),

        // SPI
        .o_mosi                     (o_mosi)
    );

    cmd_buffer cmd_buffer_i (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // Control
        .i_cmd_set                  (w_cmd_set),
        .i_cmd_reset                (w_cmd_reset),
        .i_next_byte                (w_next_byte),
        .o_cmd_set_done             (w_cmd_set_done),
        .o_last_byte                (w_last_byte),

        // PS AXI
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

        // cmd processor
        .o_cmd                      (w_cmd)
    );

    control control_i               (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // PS AXI
        .i_start                    (i_start),
        .i_cmd_reset                (i_cmd_reset),
        .o_done                     (o_done),

        // cmd buffer
        .o_cmd_set                  (w_cmd_set),
        .i_cmd_set_done             (w_cmd_set_done),
        .o_next_byte                (w_next_byte),
        .i_next_byte                (w_next_byte),
        .i_last_byte                (w_last_byte),
        
        // cmd processor
        .i_tx_done                  (w_tx_done),

        // sclk gen
        .o_sclk_en                  (w_sclk_en),
        .o_cmd_reset                (w_cmd_reset),
        
        // SPI
        .o_cs                       (o_cs)
    );


endmodule
