// VGA Controller Top Module:
module vga_controller #(parameter WIDTH=10)(clk_50mhz, reset, h_sync_pulse, v_sync_pulse, r, g, b, clock, VGA_BLANK_N, VGA_SYNC_N);
    input  logic clk_50mhz;     // 50Mhz clock of FPGA
    input  logic reset;         // Reset signal
    output logic h_sync_pulse;  // Horizontal Sync Pulse
    output logic v_sync_pulse;  // Vertical Sync Pulse
    output logic [7:0] r;       // Red channel (8-bit for RGB888)
    output logic [7:0] g;       // Green channel (8-bit for RGB888)
    output logic [7:0] b;       // Blue channel (8-bit for RGB888)
    output logic VGA_BLANK_N;   // Blanking signal/Display enable (active low)
    output logic VGA_SYNC_N;    // Composite sync signal (active low)
    output logic clock;         // 25Mhz clock to operate the VGA controller
    
    // Standard VGA timing parameters for 640x480 @60 Hz resolution:
    localparam logic [WIDTH-1:0] h_total       = 10'd800;   // Total pixels per line
    localparam logic [WIDTH-1:0] hsync_cnt     = 10'd96;    // Horizontal sync pulse width
    localparam logic [WIDTH-1:0] h_backp_cnt   = 10'd48;    // Horizontal back porch
    localparam logic [WIDTH-1:0] h_active_cnt  = 10'd640;   // Active pixels per line
    localparam logic [WIDTH-1:0] v_total       = 10'd525;   // Total lines per frame
    localparam logic [WIDTH-1:0] vsync_cnt     = 10'd2;     // Vertical sync pulse width
    localparam logic [WIDTH-1:0] v_backp_cnt   = 10'd33;    // Vertical back porch
    localparam logic [WIDTH-1:0] v_active_cnt  = 10'd480;   // Active lines per frame
    
    logic h_active_pulse;               // Horizontal active region indicator
    logic v_active_pulse;               // Vertical active region indicator
    logic [WIDTH-1:0] pixel_count;      // Current pixel position in scanline
    logic [WIDTH-1:0] line_count;       // Current line number in frame
    logic h_line_end;                   // End of horizontal line flag
    
    // Frame buffer output (24-bit RGB888):
    logic [23:0] rgb_output_data;
    
    // RGB output with blanking control:
    // Only display image data during active area, otherwise output black:
    assign r = VGA_BLANK_N ? rgb_output_data[23:16] : 8'h00;  // Red channel
    assign g = VGA_BLANK_N ? rgb_output_data[15:8]  : 8'h00;  // Green channel
    assign b = VGA_BLANK_N ? rgb_output_data[7:0]   : 8'h00;  // Blue channel
    
    assign VGA_SYNC_N = '0;  // Composite sync signal (set to 0)
    
    // Horizontal Sync Pulse Generator FSM:
    sync_pulse_generator #(.WIDTH(WIDTH)) HORIZONTAL_FSM (
        .clock(clock),
        .reset(reset),
        .total_cnt(h_total),
        .sync_cnt(hsync_cnt),
        .backp_cnt(h_backp_cnt),
        .active_cnt(h_active_cnt),
        .sync_pulse(h_sync_pulse),
        .active_pulse(h_active_pulse)
    );
    
    // Vertical Sync Pulse Generator FSM:
    sync_pulse_generator #(.WIDTH(WIDTH)) VERTICAL_FSM (
        .clock(h_line_end),
        .reset(reset),
        .total_cnt(v_total),
        .sync_cnt(vsync_cnt),
        .backp_cnt(v_backp_cnt),
        .active_cnt(v_active_cnt),
        .sync_pulse(v_sync_pulse),
        .active_pulse(v_active_pulse)
    );
    
    // Pixel Generator Module:
    pixel_generator PIXEL_GENERATOR (
        .pixel_count(pixel_count),    
        .line_count(line_count),
        .active_area(VGA_BLANK_N),
        .h_line_end(h_line_end),
        .clock(clock),      
        .reset(reset)
    );    
    
    // Frame Buffer Module (ROM with image data):
    frame_buffer #(
        .WIDTH(640),
        .HEIGHT(480),
        .PIXEL_BITS(24)  
    ) IMAGE_BUFFER (
        .clock(clock),
        .x(pixel_count),
        .y(line_count),
        .rgb_output_data(rgb_output_data)
    );
    
    // Clock Divider Module:
    clk_25mhz clock_divider(
        .clk_50mhz(clk_50mhz),
        .reset(reset),
        .clk_25mhz(clock)
    );
    
endmodule