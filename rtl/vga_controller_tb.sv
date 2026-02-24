// Testbench:

`timescale 1ns/1ps

module vga_controller_tb;

    localparam WIDTH = 10;

    // DUT inputs:
    logic clk_50mhz;
    logic reset;

    // DUT outputs:
    logic h_sync_pulse;
    logic v_sync_pulse;
    logic [7:0] r, g, b;
    logic VGA_BLANK_N;
    logic VGA_SYNC_N;
    logic clock;          // 25 MHz pixel clock

    // DUT Instantiation:
    vga_controller #(.WIDTH(WIDTH)) dut (
        .clk_50mhz(clk_50mhz),
        .reset(reset),
        .h_sync_pulse(h_sync_pulse),
        .v_sync_pulse(v_sync_pulse),
        .r(r),
        .g(g),
        .b(b),
        .clock(clock),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N)
    );

    // Clock Generation:
    initial begin
        clk_50mhz = 0;
        forever #10 clk_50mhz = ~clk_50mhz;
    end

    // Stimulus:
    initial begin
        reset = 1;
        #100;
        reset = 0;

        #100_000_000;

        $finish;
    end

endmodule