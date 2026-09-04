`timescale 1ns/1ps
module tb_tdc_timestamp;
    reg clk=0, rst_n=0, event_in=0;
    wire timestamp_valid;
    wire [31:0] timestamp, event_count;

    tdc_timestamp dut(.clk(clk),.rst_n(rst_n),.event_in(event_in),
                      .timestamp_valid(timestamp_valid),.timestamp(timestamp),.event_count(event_count));
    always #5 clk=~clk;

    task pulse_event;
      begin event_in=1; @(posedge clk); event_in=0; end
    endtask

    always @(posedge clk)
      if (timestamp_valid) $display("TDC EVENT @ %0t ns, timestamp=%0d ticks, count=%0d", $time, timestamp, event_count);

    initial begin
      $dumpfile("tdc.vcd"); $dumpvars(0,tb_tdc_timestamp);
      #20 rst_n=1;
      repeat(10) @(posedge clk);
      pulse_event;
      repeat(17) @(posedge clk);
      pulse_event;
      repeat(7) @(posedge clk);
      pulse_event;
      repeat(5) @(posedge clk);
      $display("Final event_count=%0d", event_count);
      #20 $finish;
    end
endmodule
