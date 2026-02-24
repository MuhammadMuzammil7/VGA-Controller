// Clock Divider Module (Output: 25Mhz):
module clk_25mhz (clk_50mhz, reset, clk_25mhz);
    input  logic clk_50mhz;
    input  logic reset;
    output logic clk_25mhz;

    always_ff @(posedge clk_50mhz or posedge reset) begin
        if (reset)
            clk_25mhz <= 1'b0;
        else
            clk_25mhz <= ~clk_25mhz;  
    end

endmodule