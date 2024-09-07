module wait_counter #(
        parameter               THRESHOLD       =       0,
        parameter               MODE            =       0 // 0 : tick, 1 : toggle
)(
        input       wire        i_clk,
        input       wire        i_n_reset,
        input       wire        i_enable,
        output      wire        o_tick
    );

    reg [31 : 0]                r_count;
    reg                         r_tick;

    always @(posedge i_clk) begin
       if (!i_n_reset) begin
            r_tick  <=  1'b0;
            r_count <=  32'h0000_0000;
       end 
       else begin
            if (i_enable) begin
                if (r_count == THRESHOLD-1) begin
                    if (MODE == 1) begin
                        r_tick  <=  ~r_tick;
                    end
                    else if (MODE == 0) begin
                        r_tick  <=  1'b1;
                    end
                    else begin
                       r_tick   <=  1'bz; 
                    end
                    r_count <= 32'h0000_0000;
                end
                else begin
                    if (MODE == 1) begin
                        r_tick  <=  r_tick;
                    end
                    else if (MODE == 0) begin
                        r_tick  <=  1'b0;
                    end
                    else begin
                       r_tick   <=  1'bz; 
                    end
                    r_count <= r_count + 32'h1;
                end
            end
            else begin
                if (MODE == 1) begin
                    r_tick  <=  1'b0;
                end
                else if (MODE == 0) begin
                    r_tick  <=  1'b0;
                end
                else begin
                    r_tick  <=  1'bz; 
                end
                r_count <= 32'h0;
            end
       end
    end
    assign o_tick = r_tick;

endmodule
