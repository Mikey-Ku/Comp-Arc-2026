module rgb_hsv_pwm #(
    parameter CLK_HZ = 12_000_000
)(
    input logic     clk,
    output logic    red,
    output logic    green,
    output logic    blue,
    output logic    [7:0] red_value,
    output logic    [7:0] green_value,
    output logic    [7:0] blue_value,
    output logic    [9:0] hue
);

    localparam STEPS = 768;
    localparam STEP_INTERVAL = CLK_HZ / STEPS;

    logic [$clog2(STEP_INTERVAL) - 1:0] count = 0;
    logic [7:0] pwm_count = 0;

    logic [2:0] sector;
    logic [7:0] ramp;

    initial begin
        hue = 0;
    end

    always_ff @(posedge clk) begin
        if (count == STEP_INTERVAL - 1) begin
            count <= 0;
            if (hue == STEPS - 1)
                hue <= 0;
            else
                hue <= hue + 1;
        end
        else begin
            count <= count + 1;
        end
    end

    always_ff @(posedge clk) begin
        pwm_count <= pwm_count + 1;
    end

    assign sector = hue[9:7];
    assign ramp = {hue[6:0], 1'b0};

    always_comb begin
        red_value = 0;
        green_value = 0;
        blue_value = 0;

        case (sector)
            0: begin
                red_value = 255;
                green_value = ramp;
            end
            1: begin
                red_value = 255 - ramp;
                green_value = 255;
            end
            2: begin
                green_value = 255;
                blue_value = ramp;
            end
            3: begin
                green_value = 255 - ramp;
                blue_value = 255;
            end
            4: begin
                red_value = ramp;
                blue_value = 255;
            end
            5: begin
                red_value = 255;
                blue_value = 255 - ramp;
            end
        endcase
    end

    assign red = (pwm_count < red_value);
    assign green = (pwm_count < green_value);
    assign blue = (pwm_count < blue_value);

endmodule
