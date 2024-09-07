module control (
    // System
    input       wire                    i_clk,
    input       wire                    i_n_reset,

    // PS AXI
    output      wire                    o_done,
    input       wire                    i_fetch,

    // data_transfer
    input       wire                    i_cmd_set,
    input       wire                    i_rx_data_single_byte_valid,

    // chip_selector
    input       wire                    i_cs_low_set,
    input       wire                    i_cs_high_set,
    output      wire                    o_cs_low_set,
    output      wire                    o_cs_high_set,

    // wait_counter
    output      wire                    o_wait_15_us_en,
    output      wire                    o_wait_25_us_en,
    input       wire                    i_wait_15_us_done,
    input       wire                    i_wait_25_us_done,

    // data_shifter
    input       wire                    i_rx_data_multiple_byte_valid,

    // sclk_generator
    output      wire                    o_sclk_enable
);

    localparam [2 : 0] IDLE     = 3'h0;
    localparam [2 : 0] CS_LOW   = 3'h1;
    localparam [2 : 0] WAIT_15  = 3'h2;
    localparam [2 : 0] BYTE_TX  = 3'h3;
    localparam [2 : 0] CS_HIGH  = 3'h4;
    localparam [2 : 0] WAIT_25  = 3'h5;
    localparam [2 : 0] DONE     = 3'h6;

    reg [2 : 0] present_state;
    reg [2 : 0] next_state;

    always @(posedge i_clk) begin
        if (!i_n_reset) begin
            present_state <= IDLE;
        end
        else begin
            present_state <= next_state;
        end
    end

    always @(*) begin
        if (!i_n_reset) begin
            next_state = IDLE;
        end
        else begin
            case (present_state)
            
                IDLE    : begin
                    if (i_cmd_set) begin
                        next_state = CS_LOW;
                    end
                    else begin
                        next_state = IDLE;
                    end
                end

                CS_LOW : begin
                    if (i_cs_low_set) begin
                        next_state = WAIT_15;
                    end
                    else begin
                        next_state = CS_LOW;
                    end
                end

                WAIT_15 : begin
                    if (i_rx_data_multiple_byte_valid) begin
                        next_state = CS_HIGH;
                    end
                    else if (i_wait_15_us_done) begin
                        next_state = BYTE_TX;
                    end 
                    else begin
                        next_state = WAIT_15;
                    end
                end

                BYTE_TX : begin
                    if (i_rx_data_single_byte_valid) begin
                        next_state = WAIT_15;
                    end
                    else begin
                        next_state = BYTE_TX; 
                    end
                end

                CS_HIGH : begin
                    if (i_cs_high_set) begin
                        next_state = WAIT_25;
                    end
                    else begin
                        next_state = CS_HIGH;
                    end
                end

                WAIT_25 : begin
                    if (i_wait_25_us_done) begin
                        next_state = DONE;
                    end
                    else begin
                        next_state = WAIT_25;
                    end
                end

                DONE : begin
                    if (i_fetch) begin
                        next_state = IDLE;
                    end
                    else begin
                        next_state = DONE;
                    end
                end

                default: next_state = IDLE;
            endcase
        end
    end

    reg r_cs_low_set;
    reg r_cs_high_set;
    reg r_wait_15_enable;
    reg r_wait_25_enable;
    reg r_sclk_enable;
    reg r_done;

    always @(*) begin
       if (!i_n_reset) begin
            r_cs_low_set        =   1'b0;
            r_cs_high_set       =   1'b1;
            r_wait_15_enable    =   1'b0;
            r_wait_25_enable    =   1'b0;
            r_sclk_enable       =   1'b0;
            r_done              =   1'b0;
       end 
       else begin
            case (present_state)
            
                IDLE    : begin
                    r_cs_low_set        =   1'b0;
                    r_cs_high_set       =   1'b1;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b0;
                    r_done              =   1'b0;
                end

                CS_LOW : begin
                    r_cs_low_set        =   1'b1;
                    r_cs_high_set       =   1'b0;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b0; 
                    r_done              =   1'b0;
                end

                WAIT_15 : begin
                    r_cs_low_set        =   1'b1;
                    r_cs_high_set       =   1'b0;
                    r_wait_15_enable    =   1'b1;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b0;
                    r_done              =   1'b0;
                end

                BYTE_TX : begin
                    r_cs_low_set        =   1'b1;
                    r_cs_high_set       =   1'b0;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b1; 
                    r_done              =   1'b0;
                end

                CS_HIGH : begin
                    r_cs_low_set        =   1'b0;
                    r_cs_high_set       =   1'b1;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b0; 
                    r_done              =   1'b0;
                end

                WAIT_25 : begin
                    r_cs_low_set        =   1'b0;
                    r_cs_high_set       =   1'b1;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b1;
                    r_sclk_enable       =   1'b0; 
                    r_done              =   1'b0;
                end

                DONE : begin
                    r_cs_low_set        =   1'b0;
                    r_cs_high_set       =   1'b0;
                    r_wait_15_enable    =   1'b0;
                    r_wait_25_enable    =   1'b0;
                    r_sclk_enable       =   1'b0; 
                    r_done              =   1'b1;
                end

                default : begin
                    r_cs_low_set        =   1'bz;
                    r_cs_high_set       =   1'bz;
                    r_wait_15_enable    =   1'bz;
                    r_wait_25_enable    =   1'bz;
                    r_sclk_enable       =   1'bz;
                    r_done              =   1'bz;
                end
            endcase
       end  
    end

    assign o_cs_low_set         =   r_cs_low_set;
    assign o_cs_high_set        =   r_cs_high_set;
    assign o_wait_15_us_en      =   r_wait_15_enable;
    assign o_wait_25_us_en      =   r_wait_25_enable;
    assign o_sclk_enable        =   r_sclk_enable;
    assign o_done               =   r_done;
    
endmodule