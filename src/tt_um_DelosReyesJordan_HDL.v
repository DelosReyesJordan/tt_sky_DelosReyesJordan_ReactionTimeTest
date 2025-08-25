module tt_um_DelosReyesJordan_HDL (
    input  wire [7:0] ui_in,     // general inputs (buttons)
    output wire [7:0] uo_out,    // LED + 7-segment segments
    input  wire [7:0] uio_in,    // unused
    output wire [7:0] uio_out,   // anode signals (lower 4 bits)
    output wire [7:0] uio_oe,    // anode output enable (lower 4 bits)
    input  wire       ena,       // always 1
    input  wire       clk,       // system clock
    input  wire       rst_n      // active-low reset
);

    // Active-high reset
    wire reset = ~rst_n;

    // Lower 4 bits of uio assigned to top module
    wire [3:0] an;
    wire [3:0] oe;

    // Connect reaction_time_top
    reaction_time_top top (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(an),
        .uio_oe(oe),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Map lower 4 bits to uio_out and uio_oe
    assign uio_out[3:0] = an;
    assign uio_out[7:4] = 4'b0000;       // unused upper 4 bits
    assign uio_oe[3:0]  = oe;
    assign uio_oe[7:4]  = 4'b0000;       // unused upper 4 bits

    // Prevent unused input warnings
    wire unused = (&uio_in) & ena;

endmodule
