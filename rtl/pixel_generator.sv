// Pixel Generator Module:
module pixel_generator #(parameter WIDTH = 10) (clock, reset, pixel_count, line_count, active_area, h_line_end);
    input logic clock;
    input logic reset;
    output logic [WIDTH-1:0] pixel_count;   // x-coordinate in active area 
    output logic [WIDTH-1:0] line_count;    // y-coordinate in active area 
    output logic active_area; 	            // active area
    output logic h_line_end;		        // End of horizontal line flag
    
    // VGA Timing Parameters:
    localparam logic [WIDTH-1:0] Hbp       = 10'd48;   // Horizontal back porch
    localparam logic [WIDTH-1:0] Vbp       = 10'd33;   // Vertical back porch
    localparam logic [WIDTH-1:0] hsync_cnt = 10'd96;   // Horizontal sync pulse width
    localparam logic [WIDTH-1:0] vsync_cnt = 10'd2;    // Vertical sync pulse width
    localparam logic [WIDTH-1:0] h_total   = 10'd800;  // Total pixels per line
    localparam logic [WIDTH-1:0] v_total   = 10'd525;  // Total lines per frame
    localparam logic [WIDTH-1:0] h_active  = 10'd640;  // Active pixels per line
    localparam logic [WIDTH-1:0] v_active  = 10'd480;  // Active lines per frame
    logic [WIDTH-1:0] h_count; // Horizontal counter
    logic [WIDTH-1:0] v_count; // Vertical counter

    // Horizontal counter: 
    always_ff @(posedge clock or posedge reset) begin 
        if (reset) 
            h_count <= 0; 
        else if (h_count == h_total - 1) 
            h_count <= 0; 
        else 
            h_count <= h_count + 1; 
    end 
    
    assign h_line_end = (h_count == h_total - 1);

    // Vertical counter: 
    always_ff @(posedge clock or posedge reset) begin 
        if (reset) 
            v_count <= 0; 
        else if (h_line_end) begin 
            if (v_count == v_total - 1) 
                v_count <= 0; 
            else 
                v_count <= v_count + 1; 
        end 
    end 

    // Detect active display area: 
    assign active_area = (h_count >= (hsync_cnt + Hbp)) && (h_count < (hsync_cnt + Hbp + h_active)) && (v_count >= (vsync_cnt + Vbp)) && (v_count < (vsync_cnt + Vbp + v_active)); 

    // Output pixel coordinates: 
    always_ff @(posedge clock or posedge reset) begin 
        if (reset) begin 
            pixel_count <= 0; 
            line_count <= 0; 
        end 
        else if (active_area) begin 
            pixel_count <= h_count - (hsync_cnt + Hbp); 
            line_count  <= v_count - (vsync_cnt + Vbp); 
        end 
    end 

endmodule 