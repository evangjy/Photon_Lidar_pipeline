#!/bin/sh
set -e
iverilog -g2012 -o afe_sim rtl/afe_event_detector.v tb/tb_afe_event_detector.v
vvp afe_sim
