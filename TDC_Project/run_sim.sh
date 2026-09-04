#!/bin/sh
set -e
iverilog -g2012 -o tdc_sim rtl/tdc_timestamp.v tb/tb_tdc_timestamp.v
vvp tdc_sim
