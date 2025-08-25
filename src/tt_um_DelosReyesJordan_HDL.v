module tt_um_DelosReyesJordan_HDL (
    input  wire [7:0] ui_in,     // general inputs (buttons)
    output wire [7:0] uo_out,    // segments and LED
    input  wire [7:0] uio_in,    // not used
    output wire [7:0] uio_out,   // anode signals
    output wire [7:0] uio_oe,    // anode enable signals
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
        .uio_out(uio_out),
        .uio_oe(uio_oe),  // <- now must be 8 bits wide inside dut too
        .clk(clk),
        .rst_n(rst_n)
    );

    // Prevent unused input warnings
    wire unused = (&uio_in) & ena;

endmodule

