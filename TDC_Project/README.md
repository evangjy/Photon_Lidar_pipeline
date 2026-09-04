# TDC_Project — Minimal FPGA timestamp unit

A standalone, synthesizable first-demo TDC abstraction for SPAD LiDAR.

Flow:
`photon_event` -> free-running counter -> captured timestamp -> `timestamp_valid`

The timestamp is a **coarse FPGA-clock timestamp**, not a true sub-nanosecond TDC. It is intentionally simple so it can be connected to the AFE demo first.

## Run
Requires Icarus Verilog:

    ./run_sim.sh

## Interface
- `event_in`: one-cycle photon detection event
- `timestamp`: captured counter value
- `timestamp_valid`: one-cycle strobe for a new timestamp
- `event_count`: number of captured events

## Next upgrade
A real LiDAR TDC can replace the counter with a carry-chain/TDL or dedicated TDC while keeping the downstream timestamp interface essentially the same.
