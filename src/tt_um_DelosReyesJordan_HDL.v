module tt_um_DelosReyesJordan_HDL (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire reset = ~rst_n;

    wire [3:0] an;
    wire [3:0] oe;

    reaction_time_top top (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(an),
        .uio_oe(oe),
        .clk(clk),
        .rst_n(rst_n)
    );

    assign uio_out[3:0] = an;
    assign uio_out[7:4] = 4'b0000;
    assign uio_oe[3:0]  = oe;
    assign uio_oe[7:4]  = 4'b0000;

    wire unused = (&uio_in) & ena;

endmodule
