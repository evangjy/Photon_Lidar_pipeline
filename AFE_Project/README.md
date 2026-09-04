# AFE_Project — Digital AFE abstraction for SPAD LiDAR

This is a small, standalone simulation project. It models the **digital output of an AFE/ADC path** rather than analog transistor-level AFE circuitry.

Flow:
ADC samples -> threshold crossing -> one-cycle `photon_event` -> TDC trigger

## Run
Requires Icarus Verilog:

    ./run_sim.sh

Expected output contains several `AFE EVENT` lines.

## Parameters
- `ADC_WIDTH`: ADC sample width (default 12 bits)
- `BASELINE`: nominal baseline (documentation/reference value)
- `THRESHOLD`: trigger threshold
- `HOLD_OFF_CYCLES`: dead time after an event

## Hardware use
The RTL is synthesizable and can be placed after an ADC interface. For the actual DaVinci Pro + ADDA board, the ADC interface module should be adapted to the board's ADC clock/data protocol. This project deliberately keeps that board-specific layer separate.
