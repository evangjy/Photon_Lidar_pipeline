`timescale 1ns/1ps
module lidar_pipeline_demo(
    input wire clk,
    input wire rst_n,
    input wire event_in,
    output reg [31:0] timestamp,
    output reg timestamp_valid
);
    reg [31:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 0;
            timestamp <= 0;
            timestamp_valid <= 0;
        end else begin
            counter <= counter + 1'b1;
            timestamp_valid <= event_in;

            if(event_in)
                timestamp <= counter;
        end
    end
endmodule
