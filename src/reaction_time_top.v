module reaction_time_top (
    input wire clk,
    input wire reset_btn,
    input wire go_btn,
    input wire react_btn,
    output wire go_led,
    output wire done,
    output wire [6:0] seg,
    output wire [3:0] an
);
    
    wire start_timer;
    wire stop_timer;
    wire reset_timer;
    wire [13:0] elapsed_time;

    wire show_error;
    // value to send to display
    wire [13:0] value_to_display;

    reaction_fsm fsm (
        .clk(clk),
        .reset(reset_btn),
        .go_btn(go_btn),
        .react_btn(react_btn),
        .start_timer(start_timer),
        .stop_timer(stop_timer),
        .reset_timer(reset_timer),
        .go_led(go_led),
        .done(done),
        .show_error(show_error)
    );

    timer tmr (
        .clk(clk),
        .reset(reset_btn),
        .start(start_timer),
        .stop(stop_timer),
        .reset_timer(reset_timer),
        .elapsed_time(elapsed_time)
    );

    assign value_to_display = elapsed_time;

    seg7_driver display (
        .clk(clk),
        .reset(reset_btn),
        .value(value_to_display),
        .show_error(show_error),
        .seg(seg),
        .an(an)
    );

endmodule
