`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/29 14:21:33
// Design Name: 
// Module Name: control
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


module control(
        input       wire        i_clk,
        input       wire        i_n_reset,

        input       wire        i_start,
        input       wire        i_cmd_reset,
        input       wire        i_cmd_set_done,
        input       wire        i_tx_done,
        input       wire        i_next_byte,
        input       wire        i_last_byte,
        
        output      wire        o_sclk_en,
        output      wire        o_cmd_set,
        output      wire        o_next_byte,

        output      wire        o_cmd_reset,
        output      wire        o_done,
        output      wire        o_cs
    );

    localparam [2 : 0]      IDLE        =   3'd0,
                            CMD_SET     =   3'd1,
                            TX          =   3'd2,
                            NEXT_BYTE   =   3'd3,
                            DONE        =   3'd4;

    reg [2 : 0]     present_state;
    reg [2 : 0]     next_state;

    reg r_cmd_set;
    reg r_next_byte;
    reg r_done;
    reg r_sclk_en;
    reg r_cmd_reset;
    reg r_cs;

    always @(posedge i_clk) begin : STATE_TRANSITION
        if (!i_n_reset) begin
            present_state <= IDLE;
        end
        else begin
            present_state <= next_state;
        end
    end

    always @(*) begin : DETERMINE_NEXT_STATE
        if (!i_n_reset) begin
            next_state  =   IDLE;
        end
        else begin
            case (present_state)

                IDLE    : begin
                    if (i_start) begin
                        next_state = CMD_SET;
                    end
                    else begin
                        next_state = IDLE; 
                    end
                end

                CMD_SET : begin
                    if (i_cmd_set_done) begin
                        next_state = TX;
                    end
                    else begin
                        next_state = CMD_SET;
                    end
                end

                TX : begin
                    if (i_tx_done) begin
                        next_state = NEXT_BYTE;
                    end
                    else begin
                        next_state = TX;
                    end
                end

                NEXT_BYTE : begin
                    if (i_last_byte) begin
                        next_state = DONE;
                    end
                    else if (i_next_byte) begin
                        next_state = TX;
                    end
                    else begin
                        next_state = NEXT_BYTE;
                    end
                end

                DONE : begin
                    if (i_cmd_reset) begin
                        next_state = IDLE;
                    end
                    else begin
                        next_state = DONE; 
                    end
                end

                default : next_state = IDLE;
            
    
            endcase
        end
    end

    always @(*) begin : DETERMINE_OUTPUT
       if (!i_n_reset) begin
            r_cmd_set       =   1'b0;
            r_next_byte     =   1'b0;
            r_done          =   1'b0;
            r_sclk_en       =   1'b0;
            r_cmd_reset     =   1'b0;
            r_cs            =   1'b1;
       end
       else begin
            case (present_state)
            
                IDLE    : begin
                    r_cmd_set       =   1'b0;
                    r_next_byte     =   1'b0;
                    r_done          =   1'b0;
                    r_sclk_en       =   1'b0;
                    r_cmd_reset     =   1'b0;
                    r_cs            =   1'b1;
                end

                CMD_SET : begin
                    r_cmd_set       =   1'b1;
                    r_next_byte     =   1'b0;
                    r_done          =   1'b0;
                    r_sclk_en       =   1'b0;
                    r_cmd_reset     =   1'b0;
                    r_cs            =   1'b0;
                end

                TX  : begin
                    r_cmd_set       =   1'b0;
                    r_next_byte     =   1'b0;
                    r_done          =   1'b0;
                    r_cmd_reset     =   1'b0;
                    r_cs            =   1'b0;
                    r_sclk_en       =   1'b1;
                end

                NEXT_BYTE : begin
                    r_cmd_set       =   1'b0;
                    r_next_byte     =   1'b1;
                    r_done          =   1'b0;
                    r_sclk_en       =   1'b0;
                    r_cmd_reset     =   1'b0;
                    r_cs            =   1'b0;
                end

                DONE : begin
                    r_cmd_set       =   1'b0;
                    r_next_byte     =   1'b0;
                    r_done          =   1'b1;
                    r_sclk_en       =   1'b0;
                    r_cmd_reset     =   1'b1;
                    r_cs            =   1'b1;
                end

                default : begin
                    r_cmd_set       =   1'b0;
                    r_next_byte     =   1'b0;
                    r_done          =   1'b0;
                    r_sclk_en       =   1'b0;
                    r_cmd_reset     =   1'b0;
                    r_cs            =   1'b1;
                end
            endcase
       end   
    end

    assign o_cmd_set    =   r_cmd_set;
    assign o_next_byte  =   r_next_byte;
    assign o_done       =   r_done;
    assign o_sclk_en    =   r_sclk_en;
    assign o_cmd_reset  =   r_cmd_reset;
    assign o_cs         =   r_cs;

endmodule
