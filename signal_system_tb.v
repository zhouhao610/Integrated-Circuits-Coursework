`timescale 1ns/1ps
//--------------------------------------------------------------
//  Module: signal_system_tb  Copyright (c) 2025 ZHOU HAO All rights reserved.
//--------------------------------------------------------------
module signal_system_tb;
    reg clk = 0;
    reg rst = 1;

    //----------------  clock  ----------------
    always #5 clk = ~clk;   // 100?MHz

    //----------------  DUT  ------------------
    wire [11:0] x1,x2;
    wire [7:0]  x3;
    signal_gen u_gen (.clk(clk), .rst(rst), .x1(x1), .x2(x2), .x3(x3));

    //----------------  three LPFs  -----------
    wire [23:0] y1,y2,y3;
    lp_filter u_f1 (.clk(clk), .rst(rst), .x_in(x1), .y_out(y1));
    lp_filter u_f2 (.clk(clk), .rst(rst), .x_in(x2), .y_out(y2));
    lp_filter u_f3 (.clk(clk), .rst(rst), .x_in({4'd0,x3}), .y_out(y3)); // zero?extend x3 (8?bit) to 12?bit

    //----------------  reset  ----------------
    initial begin
        #25 rst = 0;  // release reset at 25?ns
    end

    //----------------  monitor ---------------
    initial begin
        $display(" time(ns)  x1   x2   x3  |  y1    y2    y3");
        $monitor("%8t  %4d.%0d  %4d.%0d  %3d | %6d %6d %6d",
                 $time,
                 x1/10, x1%10, x2/10, x2%10, x3,
                 y1/10, y2/10, y3/10);
    end

    //----------------  sim?end ---------------
    initial begin
        #300_000;   // 300?µs
        $display("\n*** Simulation finished (300 µs) ***");
        $stop;
    end
endmodule

