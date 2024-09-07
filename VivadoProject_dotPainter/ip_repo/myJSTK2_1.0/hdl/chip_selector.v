module chip_selector (
    input       wire        i_clk,
    input       wire        i_n_reset,

    input       wire        i_cs_low_set,
    input       wire        i_cs_high_set,
    output      wire        o_cs_low_set,
    output      wire        o_cs_high_set,

    output      wire        o_cs
);
    reg r_cs_low_set;
    reg r_cs_high_set;
    reg r_cs;

    always @(posedge i_clk) begin
        if (!i_n_reset) begin
            r_cs_low_set        <= 1'b0;
            r_cs_high_set       <= 1'b0;
            r_cs                <= 1'b1;
        end
        else begin
            if (i_cs_low_set) begin
                r_cs            <= 1'b0;
                r_cs_low_set    <= 1'b1;
                r_cs_high_set   <= 1'b0;
            end
            else if (i_cs_high_set) begin
                r_cs            <= 1'b1;
                r_cs_low_set    <= 1'b0;
                r_cs_high_set   <= 1'b1;
            end
            else begin
                r_cs_low_set    <= 1'b0;
                r_cs_high_set   <= 1'b0;
                r_cs            <= 1'b1;
            end
        end
    end
    assign o_cs = r_cs;
    assign o_cs_low_set = r_cs_low_set;
    assign o_cs_high_set = r_cs_high_set;

endmodule