`timescale 1ns/1ps
module coarse_tdc #(
    parameter integer WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire event_in,
    output reg timestamp_valid,
    output reg [WIDTH-1:0] timestamp
);
    reg [WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter         <= 0;
            timestamp       <= 0;
            timestamp_valid <= 1'b0;
        end 
        else begin
            counter         <= counter + 1'b1;
            timestamp_valid <= 1'b0;

            if (event_in) begin
                timestamp       <= counter;
                timestamp_valid <= 1'b1;
            end
        end
    end
endmodule
