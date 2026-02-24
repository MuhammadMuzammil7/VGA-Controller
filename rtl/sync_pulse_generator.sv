// Sync Pulse Generator Module:
module sync_pulse_generator #(parameter WIDTH = 10)(clock, reset, total_cnt, sync_cnt, backp_cnt, active_cnt, sync_pulse, active_pulse);
    input  logic clock;
    input  logic reset;
    input  logic [WIDTH-1:0] total_cnt;
    input  logic [WIDTH-1:0] sync_cnt;
    input  logic [WIDTH-1:0] backp_cnt; 
    input  logic [WIDTH-1:0] active_cnt;
    output logic sync_pulse; 
    output logic active_pulse; 

    // Define enum for FSM statesa:
    typedef enum logic [1:0] {SYNC=2'b00, BACK_PORCH=2'b01, ACTIVE=2'b10, FRONT_PORCH=2'b11} state_t;
    
    state_t current_state, next_state; 
    logic [WIDTH-1:0] cnt; 

    // Accumulated segment boundaries: 
    logic [WIDTH-1:0] sync_end, backp_end, active_end; 

    always_comb begin 
        sync_end   = sync_cnt;                         
        backp_end  = sync_end + backp_cnt;             
        active_end = backp_end + active_cnt;        
    end 

    // State Transition Logic: 
     always_comb begin
        case (current_state)
            SYNC:        next_state = (cnt == sync_end - 1)   ? BACK_PORCH  : SYNC;
            BACK_PORCH:  next_state = (cnt == backp_end - 1)  ? ACTIVE      : BACK_PORCH;
            ACTIVE:      next_state = (cnt == active_end - 1) ? FRONT_PORCH : ACTIVE;
            FRONT_PORCH: next_state = (cnt == total_cnt - 1)  ? SYNC        : FRONT_PORCH;
            default:     next_state = SYNC;
        endcase
    end

    // State Register:
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            cnt   <= 0;
            current_state <= SYNC;  
        end 
        else begin
            if (cnt >= total_cnt - 1) begin 
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
            current_state <= next_state;
        end
    end

    // Output logic: 
    always_comb begin
        case (current_state)

            SYNC: begin 
            sync_pulse = 0;	// Active low sync pulse
            active_pulse = 0; 
            end

            BACK_PORCH: begin 
            sync_pulse = 1;      
            active_pulse = 0; 
            end

            ACTIVE: begin 
            sync_pulse = 1;      
            active_pulse = 1; // Active pulse HIGH in active display area
            end

            FRONT_PORCH: begin 
            sync_pulse = 1;      
            active_pulse = 0; 
            end

            default: begin 
            sync_pulse = 1;      
            active_pulse = 0; 
            end
        endcase
    end

endmodule 

