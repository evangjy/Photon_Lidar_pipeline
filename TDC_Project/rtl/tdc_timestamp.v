`timescale 1ns/1ps
// Simple coarse TDC abstraction: free-running counter captures timestamp on event.
// For a first FPGA demo, one counter tick = one clk period.
module tdc_timestamp #(
    parameter integer COUNTER_WIDTH = 32
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     event_in,
    output reg                      timestamp_valid,
    output reg [COUNTER_WIDTH-1:0]  timestamp,
    output reg [COUNTER_WIDTH-1:0]  event_count
);
    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= '0;
            timestamp <= '0;
            timestamp_valid <= 1'b0;
            event_count <= '0;
        end else begin
            counter <= counter + 1'b1;
            timestamp_valid <= 1'b0;
            if (event_in) begin
                timestamp <= counter;
                timestamp_valid <= 1'b1;
                event_count <= event_count + 1'b1;
            end
        end
    end
endmodule
