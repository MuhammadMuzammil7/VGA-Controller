# Usage: make sim (compile and simulate)
#        make compile (compile only)
#        make clean (remove generated files)

# Simulator
SIM = vsim
VLOG = vlog
VLIB = vlib

# Work library
WORK = work

# Testbench
TB = vga_controller_tb

# Source files (list all your .sv files here)
SOURCES = \
    clk_25mhz.sv \
    sync_pulse_generator.sv \
    pixel_generator.sv \
    frame_buffer.sv \
    vga_controller.sv \
    vga_controller_tb.sv

# Simulation time
SIM_TIME = 50ms

# Compile flags
VLOG_FLAGS = -sv -work $(WORK)

# Simulation flags
VSIM_FLAGS = -voptargs=+acc -t 1ps

.PHONY: all compile sim clean

all: compile sim

# Create work library
$(WORK):
	$(VLIB) $(WORK)

# Compile all source files
compile: $(WORK)
	$(VLOG) $(VLOG_FLAGS) $(SOURCES)

# Run simulation
sim: compile
	$(SIM) $(VSIM_FLAGS) -do "run $(SIM_TIME); quit" $(WORK).$(TB)

# Run simulation with GUI
gui: compile
	$(SIM) $(VSIM_FLAGS) $(WORK).$(TB)

# Clean generated files
clean:
	rm -rf $(WORK)
	rm -f transcript
	rm -f vsim.wlf
	rm -f *.log