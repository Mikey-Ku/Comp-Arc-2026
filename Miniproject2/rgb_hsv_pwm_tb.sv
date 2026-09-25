`timescale 1ns/1fs
`include "rgb_hsv_pwm.sv"

module rgb_hsv_pwm_tb;

    localparam CLK_HZ = 12_000_000;

    logic clk = 0;
    logic [7:0] red_value, green_value, blue_value;
    logic [9:0] hue;

    rgb_hsv_pwm u0 (
        .clk            (clk),
        .red_value      (red_value),
        .green_value    (green_value),
        .blue_value     (blue_value),
        .hue            (hue)
    );

    always begin
        #(500_000_000.0 / CLK_HZ)
        clk = ~clk;
    end

    task automatic expect_vertex(
        input integer expected_hue,
        input integer expected_red,
        input integer expected_green,
        input integer expected_blue
    );
        begin
            wait (hue == expected_hue);
            @(negedge clk);
            if (red_value !== expected_red ||
                green_value !== expected_green ||
                blue_value !== expected_blue) begin
                $fatal(1,
                    "Hue %0d: expected RGB=(%0d,%0d,%0d), got (%0d,%0d,%0d)",
                    expected_hue, expected_red, expected_green, expected_blue,
                    red_value, green_value, blue_value);
            end
        end
    endtask

    initial begin
        $dumpfile("rgb_hsv_pwm.vcd");
        $dumpvars(0, red_value, green_value, blue_value);

        expect_vertex(0,   255,   0,   0);
        expect_vertex(128, 255, 255,   0);
        expect_vertex(256,   0, 255,   0);
        expect_vertex(384,   0, 255, 255);
        expect_vertex(512,   0,   0, 255);
        expect_vertex(640, 255,   0, 255);

        wait (hue == 767);
        wait (hue == 0);
        @(negedge clk);

        if ($realtime < 999_999_000.0 || $realtime > 1_000_001_000.0)
            $fatal(1, "Color cycle took %0.9f seconds instead of 1 second",
                $realtime / 1_000_000_000.0);

        $display("PASS: full-resolution color cycle took %0.9f seconds.",
            $realtime / 1_000_000_000.0);
        $finish;
    end

    initial begin
        #1_100_000_000
        $fatal(1, "Timeout waiting for the full-resolution color cycle.");
    end

endmodule
