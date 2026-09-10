`timescale 1ns/1ps
module tb_coarse_tdc;
    reg clk=0, rst_n=0, event_in=0;
    wire valid;
    wire [31:0] timestamp;

    always #10 clk=~clk; // 50 MHz

    coarse_tdc dut(
        .clk(clk), .rst_n(rst_n), .event_in(event_in),
        .timestamp_valid(valid), .timestamp(timestamp)
    );

    task photon;
        begin
            @(negedge clk);
            event_in=1;
            @(negedge clk);
            event_in=0;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb_coarse_tdc);

        #25 rst_n=1;
        repeat(3) @(posedge clk);
        photon;
        repeat(4) @(posedge clk);
        photon;
        repeat(5) @(posedge clk);
        photon;

        #40 $finish;
    end

    always @(posedge clk)
        if(valid)
            $display("timestamp = %0d", timestamp);
endmodule
