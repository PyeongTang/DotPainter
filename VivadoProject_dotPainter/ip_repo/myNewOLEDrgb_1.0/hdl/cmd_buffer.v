`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/29 14:00:41
// Design Name: 
// Module Name: cmd_buffer
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


module cmd_buffer(
        input       wire                    i_clk,
        input       wire                    i_n_reset,

        input       wire                    i_cmd_set,
        input       wire                    i_cmd_reset,

        input       wire                    i_next_byte,

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

        output      wire        [7 : 0]     o_cmd,
        output      wire                    o_cmd_set_done,
        output      wire                    o_last_byte
    );

    reg [3 : 0]     r_num_cmd;
    reg [3 : 0]     r_byte_count;
    reg             r_cmd_set_done;

    reg [7 : 0]     r_cmd_1;
    reg [7 : 0]     r_cmd_2;
    reg [7 : 0]     r_cmd_3;
    reg [7 : 0]     r_cmd_4;
    reg [7 : 0]     r_cmd_5;
    reg [7 : 0]     r_cmd_6;
    reg [7 : 0]     r_cmd_7;
    reg [7 : 0]     r_cmd_8;
    reg [7 : 0]     r_cmd_9;
    reg [7 : 0]     r_cmd_10;
    reg [7 : 0]     r_cmd_11;
    reg [7 : 0]     r_cmd_12;
    reg [7 : 0]     r_cmd_13;
    reg [7 : 0]     r_cmd_14;
    reg [7 : 0]     r_cmd_15;

    reg [7 : 0]     r_cmd_out;

    always @(posedge i_clk) begin : REGISTERING_CMDS
        if (!i_n_reset) begin
            r_cmd_set_done  <=      1'b0;
            r_cmd_1         <=      8'h00;
            r_cmd_2         <=      8'h00;
            r_cmd_3         <=      8'h00;
            r_cmd_4         <=      8'h00;
            r_cmd_5         <=      8'h00;
            r_cmd_6         <=      8'h00;
            r_cmd_7         <=      8'h00;
            r_cmd_8         <=      8'h00;
            r_cmd_9         <=      8'h00;
            r_cmd_10        <=      8'h00;
            r_cmd_11        <=      8'h00;
            r_cmd_12        <=      8'h00;
            r_cmd_13        <=      8'h00;
            r_cmd_14        <=      8'h00;
            r_cmd_15        <=      8'h00;
        end
        else if (i_cmd_reset) begin
            r_cmd_set_done  <=      1'b0;
            r_cmd_1         <=      8'h00;
            r_cmd_2         <=      8'h00;
            r_cmd_3         <=      8'h00;
            r_cmd_4         <=      8'h00;
            r_cmd_5         <=      8'h00;
            r_cmd_6         <=      8'h00;
            r_cmd_7         <=      8'h00;
            r_cmd_8         <=      8'h00;
            r_cmd_9         <=      8'h00;
            r_cmd_10        <=      8'h00;
            r_cmd_11        <=      8'h00;
            r_cmd_12        <=      8'h00;
            r_cmd_13        <=      8'h00;
            r_cmd_14        <=      8'h00;
            r_cmd_15        <=      8'h00;
        end
        else begin
            if (i_cmd_set) begin
                r_cmd_set_done  <=      1'b1;
                r_cmd_1         <=      i_cmd_1;
                r_cmd_2         <=      i_cmd_2;
                r_cmd_3         <=      i_cmd_3;
                r_cmd_4         <=      i_cmd_4;
                r_cmd_5         <=      i_cmd_5;
                r_cmd_6         <=      i_cmd_6;
                r_cmd_7         <=      i_cmd_7;
                r_cmd_8         <=      i_cmd_8;
                r_cmd_9         <=      i_cmd_9;
                r_cmd_10        <=      i_cmd_10;
                r_cmd_11        <=      i_cmd_11;
                r_cmd_12        <=      i_cmd_12;
                r_cmd_13        <=      i_cmd_13;
                r_cmd_14        <=      i_cmd_14;
                r_cmd_15        <=      i_cmd_15;
            end
        end
    end

    always @(posedge i_clk) begin : COUNTING_BYTE
        if (!i_n_reset) begin
            r_byte_count    <=      4'd0;
            r_num_cmd       <=      4'd0;
        end
        else if (i_cmd_reset) begin
            r_byte_count    <=      4'd0;
            r_num_cmd       <=      4'd0;
        end
        else if (i_cmd_set) begin
            r_byte_count    <=      4'd1;
            r_num_cmd       <=      i_num_cmd;
        end
        else begin
            if (i_next_byte) begin
                r_byte_count    <=      r_byte_count    +   4'h1;
                r_num_cmd       <=      r_num_cmd;
            end
            else begin
                r_byte_count    <=      r_byte_count;
                r_num_cmd       <=      r_num_cmd;
            end
        end
    end

    always @(*) begin : DETERMINE_TX_CMD
       if (!i_n_reset) begin
            r_cmd_out   =  8'h00;
       end 
       else if (i_cmd_reset) begin
            r_cmd_out   =   8'h00;
       end
       else begin
            case (r_byte_count)

                4'd1        : r_cmd_out = r_cmd_1;
                4'd2        : r_cmd_out = r_cmd_2;
                4'd3        : r_cmd_out = r_cmd_3;
                4'd4        : r_cmd_out = r_cmd_4;
                4'd5        : r_cmd_out = r_cmd_5;
                4'd6        : r_cmd_out = r_cmd_6;
                4'd7        : r_cmd_out = r_cmd_7;
                4'd8        : r_cmd_out = r_cmd_8;
                4'd9        : r_cmd_out = r_cmd_9;
                4'd10       : r_cmd_out = r_cmd_10;
                4'd11       : r_cmd_out = r_cmd_11;
                4'd12       : r_cmd_out = r_cmd_12;
                4'd13       : r_cmd_out = r_cmd_13;
                4'd14       : r_cmd_out = r_cmd_14;
                4'd15       : r_cmd_out = r_cmd_15;
                default     : r_cmd_out = 8'h00;

            endcase
       end
    end

    assign o_last_byte          =   (r_byte_count == r_num_cmd);
    assign o_cmd_set_done       =   r_cmd_set_done;
    assign o_cmd                =   r_cmd_out;

endmodule
