# Color Space Converter — UVM Testbench

## Project Overview

This repository contains a UVM-based testbench for a Verilog/SystemVerilog color conversion DUT that converts RGB to YCbCr. The testbench exercises the DUT using UVM sequences, agents, drivers, monitors, and scoreboarding components.

**Key points:**
- DUT: RGB -> YCbCr conversion implemented in `dut/color_conversion.sv` (top-level) and helper `dut/converter.sv`.
- UVM TB top: `tb_top.sv` instantiates the DUT and starts the UVM environment.
- Simulator integration: Makefile provided for Questa/ModelSim (uses `vlog`, `vopt`, `vsim`).

## Repository Structure

- `Makefile` — build and run targets for Questa/ModelSim
- `sim.do` — Questa simulation do-file
- `tb_top.sv` — top-level testbench
- `dut/` — device-under-test RTL
  - `color_conversion.sv`
  - `converter.sv`
- `if/` — interface definitions (`master_if.sv`, `slave_if.sv`)
- `agent/` — UVM agents, drivers, monitors, sequence items
- `env/` — UVM environment and configuration
- `analysis_components/` — monitors/checkers/predictor and analysis modules
- `test/` — UVM test definitions and test-specific configuration

## Prerequisites

- Questa/ModelSim (Makefile defaults point to a Questa installation). Update `QUESTA_HOME` in the `Makefile` if needed.
- UVM 1.2 sources (Makefile looks for UVM under `$(QUESTA_HOME)/verilog_src/uvm-1.2/`).

Ensure your PATH or Makefile variables point to the simulator installation, or modify the `Makefile` variables:

- `QUESTA_HOME` — base Questa installation path
- `UVM_HOME` — UVM sources path (defaults to `$(QUESTA_HOME)/verilog_src/uvm-1.2/`)

## Build & Run (Questa/ModelSim)

From the project root, basic targets provided by the `Makefile`:

- Build and run full simulation (compile, optimize, run):

```bash
make
```

- Run only (assumes build/opt already done):

```bash
make run
```

- Compile only:

```bash
make compile
```

- Clean generated build files:

```bash
make clean
```

To run a specific UVM test defined in the test suite, set `TEST_NAME` when invoking `make`:

```bash
make run TEST_NAME=<your_test_name>
```

The Makefile compiles the TB and DUT and runs `vsim` with the do-file `sim.do`.

## Listing Available Tests

The Makefile includes a `show_test_list` target which attempts to list UVM tests. If your tests are in the `test/` directory, you can list them directly:

```bash
ls test/*.svh
```

Or use the Makefile target (note: the target's path may assume a different layout):

```bash
make show_test_list
```

## Adding/Extending Tests

- Add test configurations to `test/` as `.svh` files (UVM test classes and configuration macros).
- Add sequences in `agent/` or a new `sequence/` folder and update `test_pkg.sv` as needed.
- Update `Makefile` `compile` list if you add new top-level SV files that need explicit inclusion.

## Debugging & Waveforms

- The `sim.do` file is invoked by the Makefile; customize it to record waveforms or run specific commands on simulation start/stop.
- For interactive debugging, run `vsim` without `-c` mode (edit `MODE` in the `Makefile` or run `make run MODE=` to override).

## Notes & Tips

- The Makefile is currently set up for Questa `vlog`/`vsim` tools. To use other simulators (VCS, Xcelium), modify the tool variables and compile/run steps in the `Makefile`.
- If you add DPI or external C components, ensure `UVM_NO_DPI` and timescale flags in `VLOG` are adjusted appropriately.

## Files of Interest

- Top-level testbench: `tb_top.sv`
- DUT RTL: `dut/color_conversion.sv`, `dut/converter.sv`
- UVM environment: `env/env.svh`, `agent/master_agent.svh`, `analysis_components/checker_m.svh`


