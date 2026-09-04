`timescale 1ns/1ps
// Simple digital AFE abstraction for SPAD/LiDAR experiments.
// Input: unsigned ADC samples. Output: one-cycle photon_event on threshold crossing.
module afe_event_detector #(
    parameter integer ADC_WIDTH = 12,
    parameter integer BASELINE = 2048,
    parameter integer THRESHOLD = 2300,
    parameter integer HOLD_OFF_CYCLES = 8
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire [ADC_WIDTH-1:0]     adc_sample,
    output reg                      photon_event,
    output reg [ADC_WIDTH-1:0]      sample_level
);
    localparam integer HOLD_W = (HOLD_OFF_CYCLES <= 1) ? 1 : $clog2(HOLD_OFF_CYCLES+1);
    reg [HOLD_W-1:0] hold_cnt;
    reg above;
    wire hit = (adc_sample >= THRESHOLD);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            photon_event <= 1'b0;
            sample_level <= BASELINE[ADC_WIDTH-1:0];
            hold_cnt <= 1'b0;
            above <= 1'b0;
        end else begin
            sample_level <= adc_sample;
            photon_event <= 1'b0;
            if (hold_cnt != 0)
                hold_cnt <= hold_cnt - 1'b1;

            // Rising threshold crossing only; suppress re-trigger during holdoff.
            if (hit && !above && (hold_cnt == 0)) begin
                photon_event <= 1'b1;
                hold_cnt <= HOLD_OFF_CYCLES[HOLD_W-1:0];
            end
            above <= hit;
        end
    end
endmodule
