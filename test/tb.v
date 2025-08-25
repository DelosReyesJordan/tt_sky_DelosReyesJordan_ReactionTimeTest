`default_nettype none
`timescale 1ns / 1ps

module tb ();

    reg clk = 0;
    reg rst_n = 0;
    reg ena = 1;
    reg [7:0] ui_in = 8'b0;
    reg [7:0] uio_in = 8'b0;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

`ifdef GL_TEST
    wire VPWR = 1'b1;
    wire VGND = 1'b0;
`endif

    // Instantiate your top module
    tt_um_DelosReyesJordan_HDL user_project (
`ifdef GL_TEST
        .VPWR(VPWR),
        .VGND(VGND),
`endif
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (ena),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Initial block for reset and input stimulus
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Hold reset for a few cycles
        rst_n = 0;
        #20;
        rst_n = 1;

        // Example stimulus (can be replaced/extended in Cocotb)
        ui_in = 8'b00000001; // Press start button
        #100;
        ui_in = 8'b00000000;
        #500;

        // End simulation after some time
        $finish;
    end

endmodule
