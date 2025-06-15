# FloppyComp-V1: A Simple Single-Cycle RISC-V CPU

Welcome to **FloppyComp-V1**, a non-pipelined Single-Cycle RISC-V CPU designed for learning, experimentation, and extension. This project is written in SystemVerilog and is organized for clarity, modularity, and ease of simulation using Vivado.

---

## Architecture Overview

### Top-Level Module (`top.sv`)

The `top` module integrates the CPU core, instruction memory, and data memory. It acts as the SoC wrapper, connecting all major components and exposing the main clock/reset interface for simulation or synthesis.

### CPU Core (`cpu.sv`)

The `cpu` module implements the RISC-V processor core. It orchestrates instruction fetch, decode, execution, memory access, and write-back. The CPU is non-pipelined, meaning each instruction completes all stages before the next begins.

#### Subsidiary Modules

- **ALU (`alu.sv`)**  
  Performs arithmetic and logic operations. Receives operands and control signals from the decode/execute stage.

- **Branch Unit (`branch_unit.sv`)**  
  Determines branch decisions based on ALU flags and branch control signals.

- **Register File (`reg_file.sv`)**  
  Holds the 32 general-purpose registers. Supports two reads and one write per cycle.

- **Instruction Fetch (`fetch.sv`)**  
  Handles program counter updates and instruction memory reads.

- **Decoder (`decode.sv`)**  
  Decodes instructions, generates immediate values, and produces control signals for the rest of the datapath.

- **Memory Stage (`memory_stage.sv`)**  
  Interfaces with data memory for load/store instructions.

- **Write-Back (`write_back.sv`)**  
  Selects the correct data to write back to the register file.

- **RAM (`ram.sv`)**  
  Simple instruction and data synchronous memory.

- **Parameters (`params.sv`)**  
  Contains global parameters, typedefs, and enums for instruction formats, opcodes, and control signals.

---

## Control Signals

- **ALU Control**: Selects the operation (add, sub, and, or, etc.).
- **Branch Control**: Determines if a branch is taken.
- **MemRead/MemWrite**: Enables memory access for load/store.
- **RegWrite**: Enables writing to the register file.
- **MemToReg**: Selects between ALU result and memory data for write-back.
- **Immediate Select**: Chooses the correct immediate format (I, S, B, etc.).

All control signals are generated in the decode stage and propagated through the datapath.

---

## Scripts

### TCL Scripts (`scripts/`)

- **simulate.tcl**  
  Automates Vivado simulation: sets up the project, adds sources, runs simulation, and opens the waveform viewer.

- **clear_dir.tcl**  
  Cleans up generated files and simulation outputs for a fresh start.

#### Usage

1. Open Vivado.
2. Source the desired script in the TCL console:
3. ```source simulate.tcl```
4. ```run_simulation <proj_name> <top_module_name> <tb_module_name>```
5. To clean up:
6. ```source clear_dir.tcl```

---

## To-Do List

- [ ] **Create a testbench for the top module**  
  Develop a comprehensive testbench to verify the integration of CPU, memory, and peripherals at the SoC level.

- [ ] **Expand `cpu_tb.sv`**  
  Add more instruction types, edge cases, and automated self-checking to the CPU testbench for thorough verification.

- [ ] **Add more programs like `program.hex`**  
  Write and include additional RISC-V programs to test various instruction sequences and features.

- [ ] **Add functionality for CSRs and their instructions**  
  Implement Control and Status Registers (CSRs) and support for CSR-related RISC-V instructions.

- [ ] **Add functionality for privilege modes**  
  Extend the CPU to support RISC-V privilege levels (user, supervisor, machine) and related control logic.

- [ ] **Create a new project for multi-cycle and pipelined CPU**  
  Start a separate project directory to design and implement multi-cycle and pipelined versions of the CPU for performance comparison and learning.

---

## Getting Started

1. Review the `src/` directory for all SystemVerilog modules.
2. Use the scripts in `scripts/` to simulate the design in Vivado.
3. Edit or replace `tests/program.hex` to run your own RISC-V programs.

---

**Happy hacking!**
