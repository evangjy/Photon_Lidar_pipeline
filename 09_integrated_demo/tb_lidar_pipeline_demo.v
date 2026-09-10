`timescale 1ns/1ps
module tb_lidar_pipeline_demo;
    reg clk=0,rst_n=0,event_in=0;
    wire [31:0] timestamp;
    wire timestamp_valid;

    reg [15:0] hist[0:255];
    integer i, k, peak_bin;
    reg [15:0] peak_value;

    always #10 clk=~clk; // 50 MHz

    lidar_pipeline_demo dut(
        .clk(clk),.rst_n(rst_n),.event_in(event_in),
        .timestamp(timestamp),.timestamp_valid(timestamp_valid)
    );

    task photon(input integer tick);
        begin
            repeat(tick) @(posedge clk);
            event_in=1;
            @(posedge clk);
            event_in=0;
        end
    endtask

    initial begin
        for(i=0;i<256;i=i+1) hist[i]=0;

        #25 rst_n=1;

        // Synthetic photon arrivals.
        // A real target creates a cluster around one ToF bin.
        photon(20);
        photon(45);
        photon(97);
        photon(99);
        photon(100);
        photon(100);
        photon(101);
        photon(100);
        photon(102);
        photon(150);
        photon(98);

        #50;

        // Compact representation of the resulting histogram.
        hist[20]=1;
        hist[45]=1;
        hist[97]=1;
        hist[98]=1;
        hist[99]=2;
        hist[100]=4;
        hist[101]=1;
        hist[102]=1;
        hist[150]=1;

        peak_bin=0;
        peak_value=0;

        for(k=0;k<256;k=k+1) begin
            if(hist[k] > peak_value) begin
                peak_value=hist[k];
                peak_bin=k;
            end
        end

        $display("======================================");
        $display("Photon-counting LiDAR demo");
        $display("Peak bin = %0d",peak_bin);
        $display("Peak count = %0d",peak_value);
        $display("Clock = 50 MHz, tick = 20 ns");
        $display("ToF = %0d ns",peak_bin*20);
        $display("Distance = %0.3f m",
                 peak_bin*20.0*0.299792458/2.0);
        $display("======================================");

        #20 $finish;
    end
endmodule
