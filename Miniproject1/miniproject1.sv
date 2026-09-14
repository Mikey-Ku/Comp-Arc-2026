module top(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    parameter STATE_INTERVAL = 2000000;

    localparam [2:0] RED     = 3'd0;
    localparam [2:0] YELLOW  = 3'd1;
    localparam [2:0] GREEN   = 3'd2;
    localparam [2:0] CYAN    = 3'd3;
    localparam [2:0] BLUE    = 3'd4;
    localparam [2:0] MAGENTA = 3'd5;

    logic [$clog2(STATE_INTERVAL) - 1:0] count = 0;
    logic [2:0] state = RED;

    always_ff @(posedge clk) begin
        if (count == STATE_INTERVAL - 1) begin
            count <= 0;
            if (state == MAGENTA)
                state <= RED;
            else
                state <= state + 1;
        end
        else
            count <= count + 1;
    end

    always_comb begin
        case (state)
            RED:     {RGB_R, RGB_G, RGB_B} = 3'b011;
            YELLOW:  {RGB_R, RGB_G, RGB_B} = 3'b001;
            GREEN:   {RGB_R, RGB_G, RGB_B} = 3'b101;
            CYAN:    {RGB_R, RGB_G, RGB_B} = 3'b100;
            BLUE:    {RGB_R, RGB_G, RGB_B} = 3'b110;
            MAGENTA: {RGB_R, RGB_G, RGB_B} = 3'b010;
            default: {RGB_R, RGB_G, RGB_B} = 3'b011;
        endcase
    end

endmodule
