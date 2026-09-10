`timescale 1ns/1ps
module tb_edge_detector;
    reg clk=0, rst_n=0, signal_in=0;
    wire event;

    always #5 clk=~clk;

    edge_detector dut(
        .clk(clk), .rst_n(rst_n),
        .signal_in(signal_in), .event(event)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb_edge_detector);

        #12 rst_n=1;
        #13 signal_in=1;
        #20 signal_in=0;
        #17 signal_in=1;
        #10 signal_in=0;
        #30 $finish;
    end
endmodule
