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

    // FSM signals
    wire start_timer, stop_timer, show_error, done;
    wire delay_done;
    wire led;
    wire [2:0] state_out;
    wire [13:0] elapsed_time;

    // Timer output
    wire [13:0] value_to_display;

    // 7-segment display signals
    wire [6:0] seg;
    wire [3:0] an;
    wire [1:0] current_digit;

    // Instantiate top-level reaction time module
    reaction_time_top dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out[3:0]),      // lower 4 bits for anodes
        .uio_oe(uio_oe[3:0]),        // lower 4 bits enable
        .clk(clk),
        .rst_n(rst_n)
    );

    // Drive remaining upper 4 bits of uio outputs to 0
    assign uio_out[7:4] = 4'b0000;
    assign uio_oe[7:4]  = 4'b0000;

    // Prevent unused input warnings
    wire unused = (&uio_in) & ena;

endmodule
