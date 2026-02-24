// Frame Buffer Module:
module frame_buffer #(parameter WIDTH = 640, HEIGHT = 480, PIXEL_BITS = 24)(clock, x, y, rgb_output_data);
    input  logic clock;
    input  logic [$clog2(WIDTH)-1:0] x;
    input  logic [$clog2(HEIGHT)-1:0] y;
    output logic [PIXEL_BITS-1:0] rgb_output_data;
    
    // Calculate total memory size:
    localparam TOTAL_PIXELS = WIDTH * HEIGHT;  
    
    // Memory array
    logic [PIXEL_BITS-1:0] memory [0:TOTAL_PIXELS-1];
    
    // Initialize memory from hex file (RGB888 format):
    initial begin
        $readmemh("car.hex", memory);
    end
    
    // Calculate address from coordinates:
    logic [$clog2(TOTAL_PIXELS)-1:0] address;
    assign address = (y * WIDTH) + x;
    
    // Read-only memory access:
    always_ff @(posedge clock) begin
        rgb_output_data <= memory[address];
    end
endmodule