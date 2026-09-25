`include "rgb_hsv_pwm.sv"

module top(
    input logic     clk,
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    logic red, green, blue;

    rgb_hsv_pwm u0 (
        .clk    (clk),
        .red    (red),
        .green  (green),
        .blue   (blue)
    );

    assign RGB_R = ~red;
    assign RGB_G = ~green;
    assign RGB_B = ~blue;

endmodule
