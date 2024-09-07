module JSTK2_driver #(
    parameter                                                       TOTAL_DATA_BYTE     = 7,
    parameter                                                       DATA_WIDTH          = 8,
    parameter                                                       TH_WAIT_15_u_sec    = 1500,
    parameter                                                       TH_WAIT_25_u_sec    = 2500,
    parameter                                                       TH_WAIT_1_Mhz       = 50,
    parameter                                                       MODE_WAIT_TICK      = 0,
    parameter                                                       MODE_WAIT_TOGGLE    = 1
)(
    // System
    input       wire                                                i_clk,
    input       wire                                                i_n_reset,

    // SPI
    input       wire                                                i_miso,
    output      wire                                                o_cs,
    output      wire                                                o_mosi,
    output      wire                                                o_sclk,

    // PS AXI
    input       wire                                                i_fetch,
    input       wire        [DATA_WIDTH-1 : 0]                      i_cmd,
    input       wire                                                i_cmd_valid,
    output      wire        [DATA_WIDTH-1 : 0]                      o_cmd_echo,

    input       wire        [DATA_WIDTH-1 : 0]                      i_param_1,
    input       wire        [DATA_WIDTH-1 : 0]                      i_param_2,
    input       wire        [DATA_WIDTH-1 : 0]                      i_param_3,
    input       wire        [DATA_WIDTH-1 : 0]                      i_param_4,

    output      wire        [TOTAL_DATA_BYTE*DATA_WIDTH-1 : 0]      o_rx_data,
    output      wire                                                o_done
);

    reg                             r_sclk_z;

    wire                            w_sclk;
    wire                            w_sclk_z;
    wire                            w_cmd_set;
    wire    [DATA_WIDTH-1 : 0]      w_rx_data_single_byte;
    wire                            w_rx_data_single_byte_valid;
    wire                            w_rx_data_multiple_byte_valid;

    wire                            w_cs_low_set;
    wire                            w_cs_high_set;
    wire                            w_cs_low_set_done;
    wire                            w_cs_high_set_done;

    wire                            w_wait_15_us_en;
    wire                            w_wait_25_us_en;
    wire                            w_wait_15_us_done;
    wire                            w_wait_25_us_done;
    wire                            w_sclk_enable;
    
    data_transfer #(
        .DATA_WIDTH                 (DATA_WIDTH)
    )   data_transfer_i             (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // sclk generator
        .i_sclk                     (w_sclk),
        .i_sclk_z                   (w_sclk_z),

        // SPI
        .i_miso                     (i_miso),
        .o_mosi                     (o_mosi),

        // PS AXI
        .i_cmd                      (i_cmd),
        .i_cmd_valid                (i_cmd_valid),
        .i_fetch                    (i_fetch),

        .i_param_1                  (i_param_1),
        .i_param_2                  (i_param_2),
        .i_param_3                  (i_param_3),
        .i_param_4                  (i_param_4),

        .o_cmd_set                  (w_cmd_set),
        .o_cmd_echo                 (o_cmd_echo),

        // data shift
        .o_rx_data                  (w_rx_data_single_byte),
        .o_rx_data_valid            (w_rx_data_single_byte_valid)
    );

    data_shift #(
        .TOTAL_DATA_BYTE            (TOTAL_DATA_BYTE),
        .DATA_WIDTH                 (DATA_WIDTH)
    )   data_shift_i                (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // data transfer
        .i_rx_data_valid            (w_rx_data_single_byte_valid),
        .i_rx_data                  (w_rx_data_single_byte),

        // PS AXI
        .i_fetch                    (i_fetch),
        .o_rx_data                  (o_rx_data),

        // Control
        .o_rx_data_valid            (w_rx_data_multiple_byte_valid)
    );

    chip_selector chip_selector_i   (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),

        // chip selector
        .i_cs_low_set               (w_cs_low_set),
        .i_cs_high_set              (w_cs_high_set),
        .o_cs_low_set               (w_cs_low_set_done),
        .o_cs_high_set              (w_cs_high_set_done),

        // SPI
        .o_cs                       (o_cs)
    );

    wait_counter #(
        .THRESHOLD                  (TH_WAIT_15_u_sec),
        .MODE                       (MODE_WAIT_TICK)
    ) wait_counter_i_15             (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),
        
        // Control
        .i_enable                   (w_wait_15_us_en),
        .o_tick                     (w_wait_15_us_done)
    );

    wait_counter #(
        .THRESHOLD                  (TH_WAIT_25_u_sec),
        .MODE                       (MODE_WAIT_TICK)
    ) wait_counter_i_25             (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),
        
        // Control
        .i_enable                   (w_wait_25_us_en),
        .o_tick                     (w_wait_25_us_done)
    );

    wait_counter #(
        .THRESHOLD                  (TH_WAIT_1_Mhz),
        .MODE                       (MODE_WAIT_TOGGLE)
    ) sclk_generator                (
        // System
        .i_clk                      (i_clk),
        .i_n_reset                  (i_n_reset),
        
        // Control
        .i_enable                   (w_sclk_enable),

        // data transfer, shift, SPI
        .o_tick                     (w_sclk)
    );

    always @(posedge i_clk) begin
        if (!i_n_reset) begin
            r_sclk_z <= 1'b0;
        end
        else begin
            r_sclk_z <= w_sclk;
        end
    end
    assign w_sclk_z = r_sclk_z;
    assign o_sclk   = r_sclk_z; // Delayed

    control control_i                           (
        // System
        .i_clk                                  (i_clk),
        .i_n_reset                              (i_n_reset),

        // PS AXI
        .o_done                                 (o_done),
        .i_fetch                                (i_fetch),

        // data transfer
        .i_cmd_set                              (w_cmd_set),
        .i_rx_data_single_byte_valid            (w_rx_data_single_byte_valid),

        // chip selector
        .i_cs_low_set                           (w_cs_low_set_done),
        .i_cs_high_set                          (w_cs_high_set_done),
        .o_cs_low_set                           (w_cs_low_set),
        .o_cs_high_set                          (w_cs_high_set),

        // wait counter
        .o_wait_15_us_en                        (w_wait_15_us_en),
        .o_wait_25_us_en                        (w_wait_25_us_en),
        .i_wait_15_us_done                      (w_wait_15_us_done),
        .i_wait_25_us_done                      (w_wait_25_us_done),

        // data shift
        .i_rx_data_multiple_byte_valid          (w_rx_data_multiple_byte_valid),

        // sclk generator
        .o_sclk_enable                          (w_sclk_enable)
    );


endmodule