`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/28 14:20:20
// Design Name: 
// Module Name: cmd_processor
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


module cmd_processor(
        // System
        input       wire                    i_clk,
        input       wire                    i_n_reset,
        
        // wait counter
        input       wire                    i_sclk,     // SPI MOSI ready sclk
        input       wire                    i_sclk_z,   // SPI SCLK
        input       wire                    i_sclk_zz,

        // Control
        input       wire                    i_cmd_set,
        input       wire                    i_cmd_reset,
        input       wire                    i_next_byte,
        input       wire        [7 : 0]     i_tx_data,
        output      wire                    o_done,

        // SPI
        output      wire                    o_mosi
    );

    /*
    SPI Mode 3
    SCLK IDLE       : H
    DATA CAPTURE    : R
    DATA TX         : F

    and with a minimum clock cycle time of 150 ns
    */

    wire        w_last_tx_done;

    // PS AXI
    reg [7 : 0] r_tx_data;

    // SPI
    reg         r_mosi;
    
    reg [3 : 0] r_bit_count;

    reg r_next_byte;
    always @(posedge i_clk) begin : DELAYING_NEXT_BYTE
        if (!i_n_reset) begin
            r_next_byte <= 1'b0;
        end
        else begin
            r_next_byte <= i_next_byte;
        end
    end

    always @(posedge i_clk) begin : BUFFERING_TX_DATA
       if (!i_n_reset) begin
            r_tx_data <= 8'h00;
       end
       else if (i_cmd_reset) begin
            r_tx_data <= 8'h00;
       end
       else begin
            if (i_cmd_set) begin
                    r_tx_data <= i_tx_data;
            end
            else if (r_next_byte) begin
                    r_tx_data <= i_tx_data;
            end
            else begin
                    r_tx_data <= r_tx_data;
            end
       end
    end

    always @(posedge i_sclk_z or negedge i_n_reset) begin : MOSI_BIT_SELECT
       if (!i_n_reset) begin
            r_mosi <= 1'b0;
       end
       else begin
            if (r_bit_count <= 4'd7) begin
                r_mosi <= r_tx_data[r_bit_count];  // MSB First
            end
            else begin
                r_mosi <= 1'b0;
            end
       end  
    end

    // data set : R
    // data tx  : F
    always @(posedge i_sclk or negedge i_n_reset) begin : COUNTING_BITS_IN_TX_BUF
        if (!i_n_reset) begin
            r_bit_count     <=  4'h8;
        end
        else if (i_cmd_reset) begin
            r_bit_count     <=  4'h8;
        end
        else begin
            if      (r_bit_count >= 4'h1) begin
                r_bit_count                 <=      r_bit_count - 4'h1;
            end
            else begin
                r_bit_count                 <=      4'h7;
            end
        end
    end

    reg r_done_z;
    reg r_done_zz;

    always @(posedge i_clk) begin : DELAYING_TX_DONE_TO_EDGE_CAPTURE
        if (!i_n_reset) begin
            r_done_z    <=  1'b0;
            r_done_zz   <=  1'b0;
        end
        else begin
            r_done_z    <=  w_last_tx_done;
            r_done_zz   <=  r_done_z;
        end
    end

    assign o_mosi           =   r_mosi;
    assign w_last_tx_done   =   (r_bit_count == 4'h0) && (i_sclk_zz);
    assign o_done           =   ~r_done_zz & r_done_z;

endmodule
