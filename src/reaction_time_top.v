module reaction_time_top (
    input  wire [7:0] ui_in,      // general inputs (buttons)
    output wire [7:0] uo_out,     // segments + LED
    output wire [3:0] uio_out,    // 7-segment anode control
    output wire [3:0] uio_oe,     // anode output enable
    input  wire       clk,        // system clock
    input  wire       rst_n       // active-low reset
);

    // Active-high reset
    wire reset = ~rst_n;

    // Map UI buttons
    wire start_btn = ui_in[0];
    wire react_btn = ui_in[1];

    // FSM control signals
    wire start_timer;
    wire stop_timer;
    wire show_error;
    wire done;
    wire [2:0] state_out;

    // Timer signals
    wire [13:0] elapsed_time;

    // 7-segment display signals
    wire [6:0] seg;
    wire [3:0] an;
    wire [13:0] value_to_display;
    wire [1:0] current_digit;

    // Instantiate reaction FSM
    reaction_fsm fsm (
        .clk(clk),
        .reset(reset),
        .start_btn(start_btn),
        .react_btn(react_btn),
        .delay_done(done),           // we use 'done' from timer as delay_done
        .elapsed_time(elapsed_time),
        .led(uo_out[0]),             // connect LED output
        .start_timer(start_timer),
        .stop_timer(stop_timer),
        .show_error(show_error),
        .done(done),
        .state_out(state_out)
    );

    // Instantiate timer
    timer tmr (
        .clk(clk),
        .reset(reset),
        .start(start_timer),
        .stop(stop_timer),
        .ms_time(elapsed_time)
    );

    // Instantiate 7-segment display driver
    seg7_driver display (
        .clk(clk),
        .reset(reset),
        .show_error(show_error),
        .value(elapsed_time),
        .seg(seg),
        .an(an),
        .digit_select(current_digit)
    );

    // Output assignments
    assign uo_out[7:1] = seg;    // 7-segment segments
    assign uio_out = an;          // anode signals
    assign uio_oe  = 4'b1111;    // enable all anodes

endmodule
