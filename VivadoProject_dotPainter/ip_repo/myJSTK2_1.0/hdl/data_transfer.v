module data_transfer #(
    parameter                                       DATA_WIDTH = 8
)(
    // System
    input       wire                                i_clk,
    input       wire                                i_n_reset,
    input       wire                                i_sclk_z,

    // SPI
    input       wire                                i_sclk,
    input       wire                                i_miso,
    output      wire                                o_mosi,
    
    // PS AXI
    input       wire        [DATA_WIDTH-1 : 0]      i_cmd,
    input       wire                                i_cmd_valid,
    input       wire                                i_fetch,

    input       wire        [DATA_WIDTH-1 : 0]      i_param_1,
    input       wire        [DATA_WIDTH-1 : 0]      i_param_2,
    input       wire        [DATA_WIDTH-1 : 0]      i_param_3,
    input       wire        [DATA_WIDTH-1 : 0]      i_param_4,

    output      wire                                o_cmd_set,
    output      wire        [DATA_WIDTH-1 : 0]      o_cmd_echo,

    // Data Shift
    output      wire        [DATA_WIDTH-1 : 0]      o_rx_data,
    output      wire                                o_rx_data_valid
);

    // Data tx
    reg                     r_mosi;
    reg [DATA_WIDTH-1 : 0]  r_rx_data;
    reg [DATA_WIDTH-1 : 0]  r_tx_data;

    // Data count
    reg [3 : 0]             r_bit_count;
    reg [2 : 0]             r_byte_count;

    // cmd set
    reg                     r_cmd_set;

    // Rx data valid signal edge
    reg                     r_rx_data_valid;
    reg                     r_rx_data_valid_z;
    reg                     r_rx_data_valid_zz;

    reg                     r_first_tx;

    // BYTE COUNT
    always @(posedge i_clk) begin
        if (!i_n_reset) begin
            r_byte_count <= 3'h0;
        end
        else if (i_fetch) begin
            r_byte_count <= 3'h0;
        end
        else begin
            if (o_rx_data_valid) begin
                r_byte_count <= r_byte_count + 3'h1;
            end
            else begin
                r_byte_count <= r_byte_count;
            end
        end
    end

    // CMD/PARAM SET
    // From PS via AXI
    always @(posedge i_clk) begin
       if (!i_n_reset) begin
            r_tx_data <= {DATA_WIDTH{1'b0}};
            r_cmd_set <= 1'b0;
       end
       else if (i_fetch) begin
            r_tx_data <= {DATA_WIDTH{1'b0}};
            r_cmd_set <= 1'b0;
       end
       else begin
            if (i_cmd_valid) begin
                case (r_byte_count)
                    3'h0    :   r_tx_data <= i_cmd;    
                    3'h1    :   begin
                                r_tx_data <= i_param_1;            
                    end
                    3'h2    :   begin
                                r_tx_data <= i_param_2;            
                    end
                    3'h3    :   begin
                                r_tx_data <= i_param_3;            
                    end
                    3'h4    :   begin
                                r_tx_data <= i_param_4;            
                    end
                    default :   r_tx_data <= i_cmd;
                endcase
                r_cmd_set <= 1'b1;
            end
            else begin
                r_tx_data <= {DATA_WIDTH{1'b0}};
                r_cmd_set <= 1'b0;
            end
        end
    end

    always @(posedge i_sclk or negedge i_n_reset) begin
       if (!i_n_reset) begin
            r_mosi <= 1'b0;
       end 
       else if (i_fetch) begin
            r_mosi <= 1'b0;
       end
       else begin
            r_mosi <= r_tx_data[r_bit_count];  // MSB First
       end  
    end

    // Posedge
    // Data transfer
    always @(posedge i_sclk_z or negedge i_n_reset) begin
        if (!i_n_reset) begin
            r_rx_data       <=  {DATA_WIDTH{1'b0}};
            r_bit_count     <=  4'h7;
        end
        else if (i_fetch) begin
            r_rx_data       <=  {DATA_WIDTH{1'b0}};
            r_bit_count     <=  4'h7;
        end
        else begin
            if (r_bit_count >= 8'h1) begin
                r_rx_data[r_bit_count]    <=      i_miso;                  // MSB First
                r_bit_count               <=      r_bit_count - 3'h1;
            end
            else if (r_bit_count == 4'h0) begin
                r_rx_data[r_bit_count]      <=      i_miso;                  // MSB First
                r_bit_count                 <=      4'h7;
            end
            else begin
                r_rx_data                   <=      r_rx_data;
                r_bit_count                 <=      r_bit_count;
            end
        end
    end

    reg [7 : 0] r_cmd_echo;
    always @(posedge i_sclk_z or negedge i_n_reset) begin
        if (!i_n_reset) begin
            r_cmd_echo      <=  8'h00;
        end
        else if (i_fetch) begin
            r_cmd_echo      <=  8'h00;
        end
        else begin
            if (r_first_tx) begin
                if (r_bit_count >= 8'h0) begin
                    r_cmd_echo[r_bit_count] <= r_mosi;
                end
                else begin
                    r_cmd_echo  <=  r_cmd_echo;
                end
            end
            else begin
                r_cmd_echo  <=  r_cmd_echo;
            end
        end
    end

    always @(negedge i_sclk or negedge i_n_reset) begin
        if (!i_n_reset) begin
            r_rx_data_valid <= 1'b0;
        end
        else begin
            if (r_bit_count == 4'h7) begin
                r_rx_data_valid <= 1'b1;
            end
            else begin
                r_rx_data_valid <= 1'b0;
            end
        end
    end

    always @(posedge i_clk or negedge i_n_reset) begin
        if (!i_n_reset) begin
            r_first_tx  <=  1'b1;
        end
        else if (i_fetch) begin
            r_first_tx  <=  1'b1;
        end
        else begin
            if (o_rx_data_valid) begin
                r_first_tx  <=  1'b0; 
            end
            else begin
                r_first_tx  <=  r_first_tx;
            end 
        end
    end

    // Capture edge for control
    always @(posedge i_clk or negedge i_n_reset) begin
       if (!i_n_reset) begin
            r_rx_data_valid_z <= 1'b0;
            r_rx_data_valid_zz <= 1'b0;
       end
       else begin
            r_rx_data_valid_z <= r_rx_data_valid;
            r_rx_data_valid_zz <= r_rx_data_valid_z;
       end
    end

    assign o_mosi           =   r_mosi;
    assign o_cmd_set        =   r_cmd_set;
    assign o_rx_data        =   r_rx_data;
    assign o_rx_data_valid  =   ~r_rx_data_valid_zz & r_rx_data_valid_z;
    assign o_cmd_echo       =   r_cmd_echo;
    
endmodule