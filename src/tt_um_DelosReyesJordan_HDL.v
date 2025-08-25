module tt_um_DelosReyesJordan_HDL (
    input  wire [7:0] ui_in,     // general inputs (buttons)
    output wire [7:0] uo_out,    // segments and LED
    input  wire [7:0] uio_in,    // not used
    output wire [3:0] uio_out,   // anode signals
    output wire [3:0] uio_oe,    // anode enable signals
    input  wire       ena,       // always 1
    input  wire       clk,       // system clock
    input  wire       rst_n      // active-low reset
);

    // Active-high reset
    wire reset = ~rst_n;

    // Map buttons
    wire start_btn = ui_in[0];
    wire react_btn = ui_in[1];

    // Instantiate top-level reaction time module
    reaction_time_top dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out({4'b0000, uio_out}), // map lower 4 bits to 7-segment anodes
        .uio_oe({4'b0000, uio_oe}),   // map lower 4 bits to anode enables
        .clk(clk),
        .rst_n(rst_n)
    );

    // Prevent unused input warnings
    wire unused = (&uio_in) & ena;

endmodule
