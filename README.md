# VGA-Controller

A VGA Controller designed in SystemVerilog for 640×480 @60Hz display generation featuring FSM-based sync generation, modular RTL architecture, and hardware implementation on DE1-SoC FPGA.

## Overview

This project presents the design and implementation of a VGA Controller using SystemVerilog for 640×480 resolution at 60 Hz refresh rate. The controller generates VGA-compliant synchronization signals and RGB output using a modular RTL architecture suitable for FPGA-based display applications.
The design utilizes a reusable finite state machine (FSM)-based Sync Pulse Generator instantiated for both horizontal and vertical timing, ensuring consistent handling of VGA timing regions including Sync Pulse, Back Porch, Active Display, and Front Porch.
The design was simulated using QuestaSim and implemented on the DE1-SoC FPGA board for hardware validation.

---

## Architecture Design

<img width="515" height="409" alt="VGA Architecture" src="https://github.com/user-attachments/assets/a3bee8b6-0287-4082-bc0f-3f9998d322a8" />

The controller follows a modular and hierarchical architecture consisting of:
- VGA Controller (Top Module)
- Sync Pulse Generator (FSM-Based)
- Pixel Generator
- Frame Buffer (ROM-Based Image Storage)
- Clock Divider

A 25 MHz pixel clock derived from the FPGA 50 MHz clock drives horizontal and vertical scanning logic. Pixel coordinates generated during the active region are used to retrieve RGB values from the frame buffer while blanking intervals output black pixels.

--- 

## VGA Timing Specifications (640×480 @60 Hz)

### Horizontal Timing
- Active Region: 640 pixels
- Front Porch: 16 pixels
- Sync Pulse: 64 pixels
- Back Porch: 80 pixels
- Total: 800 pixels per line

### Vertical Timing
- Active Region: 480 lines
- Front Porch: 3 lines
- Sync Pulse: 4 lines
- Back Porch: 13 lines
- Total: 525 lines per frame

![VGA Display](https://github.com/user-attachments/assets/e5279782-0a80-4287-b007-745339e81a9b)

---

## Tools and Technologies

- SystemVerilog — RTL Design
- Intel Quartus Prime — Synthesis and FPGA Programming
- QuestaSim — Functional Simulation
- DE1-SoC FPGA Board — Hardware Implementation

---

## Hardware Implementation

The synthesized design was deployed on the DE1-SoC FPGA board with VGA pin assignments configured in Quartus Prime. Hardware validation was performed using multiple display patterns including solid colors, gradient, and checkerboard patterns to verify synchronization and pixel addressing.

---

## Repository Structure
```
vga_controller/
│
├── rtl/
│   ├── vga_controller.sv        # Top-level VGA controller
│   ├── sync_pulse_generator.sv  # FSM-based sync pulse generator
│   ├── pixel_generator.sv       # Pixel coordinate generator
│   ├── frame_buffer.sv          # ROM-based image frame buffer
│   └── clk_25mhz.sv             # Clock divider (50 MHz → 25 MHz)
│   └── vga_controller_tb.sv     # Testbench for VGA controller
│
├── memory/
│   └── car.hex                  # Frame buffer image data
│
├── sim/
│   └── Makefile                 # Simulation compilation and run script
│
└── README.md
```

---

## Documentation

Detailed design description, simulations, and hardware validation results are available in the project documentation report included in this repository.

---

## Author

**Muhammad Muzammil Ahmed**Electronic Engineer
