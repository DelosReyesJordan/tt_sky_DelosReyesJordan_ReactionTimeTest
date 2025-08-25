// seg7_driver.v
// Drives a 4-digit 7-segment display

module seg7_driver (
    input  wire [13:0] value,        // value to display (0-9999)
    input  wire [1:0]  digit_select, // selects which digit to show
    output reg  [6:0]  seg            // 7-segment output a-g
);

    // Extract each decimal digit and mask to 4 bits
    wire [3:0] digits [3:0];

    digits[3] = (value / 1000) % 10;
    digits[2] = (value / 100)  % 10;
    digits[1] = (value / 10)   % 10;
    digits[0] = value % 10;

    reg [3:0] current_digit;

    // Select which digit to display
    always @(*) begin
        case (digit_select)
            2'b00: current_digit = digits[0];
            2'b01: current_digit = digits[1];
            2'b10: current_digit = digits[2];
            2'b11: current_digit = digits[3];
            default: current_digit = 4'd0;
        endcase
    end

    // 7-segment encoding (common anode)
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; // all segments off
        endcase
    end

endmodule

