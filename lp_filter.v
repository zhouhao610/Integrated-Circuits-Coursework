//--------------------------------------------------------------
//  Module: lp_filter   Copyright (c) 2025 ZHOU HAO All rights reserved.
//--------------------------------------------------------------

module lp_filter #(
    parameter IN_W   = 12,
    parameter OUT_W  = 24,
    parameter ALPHA  = 1350,   // numerator
    parameter SHIFT  = 17     // denominator is 2^SHIFT
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire [IN_W-1:0]      x_in,
    output reg  [OUT_W-1:0]     y_out
);
    // sign?extend input to OUTPUT width
    wire signed [OUT_W-1:0] x_ext = { {(OUT_W-IN_W){1'b0}}, x_in };
    wire signed [OUT_W:0]   diff  = x_ext - y_out;   // x[n]-y[n-1]

    wire signed [OUT_W+17:0] mult = diff * ALPHA;    // diff*?_num
    wire signed [OUT_W:0]    inc  = mult >>> SHIFT;  // /2^SHIFT ? diff*?

    always @(posedge clk or posedge rst) begin
        if (rst) y_out <= 0;
        else      y_out <= y_out + inc;
    end
endmodule