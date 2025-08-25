module reaction_time_top (
    input  wire [7:0] ui_in,   // buttons: start, react, etc.
    output wire [7:0] uo_out,  // segments and LED
    output wire [3:0] uio_out, // anodes
    output wire [3:0] uio_oe,  // anode enables
    input  wire       clk,
    input  wire       rst_n
);

    // Active-high reset
    wire reset = ~rst_n;

    // Map UI buttons
    wire start_btn = ui_in[0];
    wire react_btn = ui_in[1];

    // FSM outputs
    wire start_timer, stop_timer, show_error, done;
    wire [13:0] elapsed_time;  // optional if FSM outputs elapsed_time
    wire [2:0] state_out;      // state display, optional

    // Timer output
    wire [13:0] ms_time;

    // 7-segment outputs
    wire [3:0] an;
    wire [6:0] seg;
    wire [13:0] value_to_display;
    wire [1:0] current_digit;

    // Instantiate reaction FSM
    reaction_fsm fsm (
        .clk(clk),
        .reset(reset),
        .start_btn(start_btn),
        .react_btn(react_btn),
        .start_timer(start_timer),
        .stop_timer(stop_timer),
        .show_error(show_error),
        .done(done),
        .elapsed_time(elapsed_time),
        .state_out(state_out),
        .led(uo_out[0]) // optional direct LED output
    );

    // Instantiate timer
    timer tmr (
        .clk(clk),
        .reset(reset),
        .start(start_timer),
        .stop(stop_timer),
        .ms_time(ms_time)
    );

    // Determine value to display (choose elapsed_time or ms_time)
    assign value_to_display = show_error ? 14'd0 : ms_time;

    // Instantiate 7-segment driver
    seg7_driver display (
        .clk(clk),
        .reset(reset),
        .value(value_to_display),
        .digit_select(current_digit),
        .an(an),
        .seg(seg),
        .show_error(show_error)
    );

    // Output segments
    assign uo_out[7:1] = seg;
    assign uio_out[3:0] = an;
    assign uio_oe[3:0]  = 4'b1111;

    // Disable unused upper 4 uio pins
    assign uio_out[7:4] = 4'b0000;
    assign uio_oe[7:4]  = 4'b0000;

endmodule
