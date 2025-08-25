module seg7_driver (
    input wire clk,
    input wire reset,
    input wire show_error,
    input wire [13:0] value,   // 0–9999 decimal value
    output reg [6:0] seg,      // segments a–g
    output reg [3:0] an        // digit select (active low)
);

    // Separate registers for each digit (no arrays in Verilog-2001)
    reg [3:0] digit0, digit1, digit2, digit3;
    reg [1:0] current_digit;
    reg [3:0] curr_digit_val;

    // Digit extraction
    always @(*) begin
        if (show_error) begin
            // Show "Err" on display: digit3 = E, others = r
            digit3 = 4'hE;   // 'E'
            digit2 = 4'hF;   // We'll map 'r' in decoder
            digit1 = 4'hF;
            digit0 = 4'hF;
        end else begin
            digit3 = (value / 1000) % 10;
            digit2 = (value / 100) % 10;
            digit1 = (value / 10) % 10;
            digit0 = value % 10;
        end
    end

    // Digit multiplexing
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_digit <= 2'b00;
        else
            current_digit <= current_digit + 1;
    end

    always @(*) begin
        case (current_digit)
            2'b00: begin an = 4'b1110; curr_digit_val = digit0; end
            2'b01: begin an = 4'b1101; curr_digit_val = digit1; end
            2'b10: begin an = 4'b1011; curr_digit_val = digit2; end
            2'b11: begin an = 4'b0111; curr_digit_val = digit3; end
        endcase
    end

    // Segment decoder (common cathode, active low)
    always @(*) begin
        case (curr_digit_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110; // 'E'
            4'hF: seg = 7'b0110111; // 'r' (approximation)
            default: seg = 7'b1111111;
        endcase
    end

endmodule

