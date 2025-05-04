`timescale 1ns/1ps
//--------------------------------------------------------------
//  Module: signal_gen   Copyright (c) 2025 ZHOU HAO All rights reserved.
//--------------------------------------------------------------
module signal_gen (
    input  wire        clk,
    input  wire        rst,
    output reg  [11:0] x1,
    output reg  [11:0] x2,
    output wire [7:0]  x3
);
    localparam integer Ts1 = 10_000;   // 100?µs period in 10?ns ticks
    localparam integer Ts2 = 100;      //   1?µs period

    reg [31:0] cnt1, cnt2;

    // combinational next values ---------------------------------
    wire [11:0] x1_next = (cnt1 < Ts1/2) ?
                          (2000 * cnt1) / (Ts1/2) :
                          2000 - (2000 * (cnt1 - Ts1/2)) / (Ts1/2);
    wire [11:0] x2_next = (2000 * cnt2) / Ts2;
    assign      x3      = (x1 >= x2) ? 8'd100 : 8'd0;

    // sequential -------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt1 <= 0; cnt2 <= 0; x1 <= 0; x2 <= 0;
        end else begin
            cnt1 <= (cnt1 == Ts1-1) ? 0 : cnt1 + 1;
            cnt2 <= (cnt2 == Ts2-1) ? 0 : cnt2 + 1;
            x1   <= x1_next;
            x2   <= x2_next;
        end
    end
endmodule