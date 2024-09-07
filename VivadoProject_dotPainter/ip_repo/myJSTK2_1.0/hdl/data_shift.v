module data_shift #(
    parameter                                                               TOTAL_DATA_BYTE     = 7,
    parameter                                                               DATA_WIDTH          = 8
)(
    // System
    input       wire                                                        i_clk,
    input       wire                                                        i_n_reset,

    // PS AXI
    output      wire                [TOTAL_DATA_BYTE*DATA_WIDTH-1 : 0]      o_rx_data,
    input       wire                                                        i_fetch,

    // Data Transfer
    input       wire                [DATA_WIDTH-1 : 0]                      i_rx_data,

    // Control
    input       wire                                                        i_rx_data_valid,
    output      wire                                                        o_rx_data_valid
);

    reg [TOTAL_DATA_BYTE*DATA_WIDTH-1 : 0] r_rx_data;
    reg [3 : 0] r_count;

    always @(posedge i_clk or negedge i_n_reset) begin
       if (!i_n_reset) begin
            r_rx_data <= {TOTAL_DATA_BYTE*DATA_WIDTH{1'b1}};
       end
       else if (i_fetch) begin
            r_rx_data <= {TOTAL_DATA_BYTE*DATA_WIDTH{1'b1}};
       end
       else begin
            if (i_rx_data_valid) begin
                r_rx_data <= {r_rx_data[47 : 0], i_rx_data};
            end
            else begin
                r_rx_data <= r_rx_data;
            end
       end
    end

    always @(posedge i_clk or negedge i_n_reset) begin
       if (!i_n_reset) begin
            r_count <= 4'h0;
       end
       else if (i_fetch) begin
            r_count <= 4'h0;
       end
       else begin
            if (i_rx_data_valid) begin
                r_count <= r_count + 4'h1;
            end
            else begin
                r_count <= r_count;
            end
       end
    end
    
    assign o_rx_data = r_rx_data;
    assign o_rx_data_valid = (r_count == TOTAL_DATA_BYTE) ? 1'b1 : 1'b0;
    
endmodule