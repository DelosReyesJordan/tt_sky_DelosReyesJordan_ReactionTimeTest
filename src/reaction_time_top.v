module reaction_time_top (
    input        clk,
    input        reset_btn,
    input        start_btn,
    input        stop_btn,
    input        adc_signal,        // example button/ADC input
    output [3:0] an,               // 7-segment anodes
    output [6:0] seg               // 7-segment segments
);

    wire delay_done, start_timer, stop_timer, show_error, done;
    wire [13:0] elapsed_time;
    wire [13:0] value_to_display;      // connects to seg7 driver
    wire [1:0]  current_digit;

    reaction_fsm fsm (
        .clk(clk),
        .rst(reset_btn),
        .start_btn(start_btn),
        .stop_btn(stop_btn),
        .delay_done(delay_done),
        .elapsed_time(elapsed_time),
        .led(show_error),        // or actual LED
        .state_out()             // tie off if unused
    );

    timer tmr (
        .clk(clk),
        .reset(reset_btn),
        .start(start_timer),
        .stop(stop_timer),
        .ms_time(elapsed_time),
        .done(done)
    );

    seg7_driver display (
        .clk(clk),
        .reset(reset_btn),
        .value(value_to_display),
        .digit_select(current_digit),
        .seg(seg),
        .an(an)
    );

endmodule
