`timescale 1ns/1ps

module tb_JSTK2_driver ();

reg             i_clk           =   1'b0;
reg             i_n_reset       =   1'b1;

reg             i_miso          =   1'b0;
wire            o_cs;
wire            o_mosi;
wire            o_sclk;

reg             i_fetch         =   1'b0;
reg [7 : 0]     i_cmd           =   8'h0;
reg             i_cmd_valid     =   1'b0;

reg [7 : 0]     i_param_1       =   8'h0;
reg [7 : 0]     i_param_2       =   8'h0;
reg [7 : 0]     i_param_3       =   8'h0;
reg [7 : 0]     i_param_4       =   8'h0;

wire [47 : 0]   o_rx_data;
wire            o_done;

    JSTK2_driver JSTK2_driver_i     (
        .i_clk                          (i_clk),
        .i_n_reset                      (i_n_reset),

        .i_miso                         (i_miso),
        .o_cs                           (o_cs),
        .o_mosi                         (o_mosi),
        .o_sclk                         (o_sclk),

        .i_fetch                        (i_fetch),
        .i_cmd                          (i_cmd),
        .i_cmd_valid                    (i_cmd_valid),

        .i_param_1                      (i_param_1),
        .i_param_2                      (i_param_2),
        .i_param_3                      (i_param_3),
        .i_param_4                      (i_param_4),

        .o_rx_data                      (o_rx_data),
        .o_done                         (o_done)
    );

    always #5 i_clk = ~i_clk;
    always #5 i_miso = ~i_miso;

    initial begin
        @(posedge i_clk) i_n_reset = 1'b0;
        @(posedge i_clk) i_n_reset = 1'b1;

        #10 i_cmd       =   8'hFF;
            i_param_1   =   8'h11;
            i_param_2   =   8'h22;
            i_param_3   =   8'h33;
            i_param_4   =   8'h44;
            i_cmd_valid =   1'b1;
            i_fetch     =   1'b0;

    end

    always @(*) begin
       if (o_done) begin
            #1000 $stop();
                i_fetch     = 1'b1;
                i_cmd       = 8'h00;
                i_cmd_valid = 1'b0;

            #10 i_cmd       = 8'h71;
                i_cmd_valid = 1'b1;
                i_fetch     = 1'b0;

       end 
    end

    

endmodule
