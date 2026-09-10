`timescale 1ns/1ps
module tb_time_gate;
    reg [31:0] timestamp;
    reg timestamp_valid;
    wire event_valid;

    time_gate #(.START_BIN(80),.END_BIN(160)) dut(
        .timestamp(timestamp),
        .timestamp_valid(timestamp_valid),
        .event_valid(event_valid)
    );

    initial begin
        $monitor("t=%0t timestamp=%0d valid=%b gate=%b",
                 $time,timestamp,timestamp_valid,event_valid);

        timestamp_valid=0; timestamp=0;
        #10 timestamp=50;  timestamp_valid=1;
        #10 timestamp=100;
        #10 timestamp=160;
        #10 timestamp=200;
        #10 timestamp_valid=0;
        #20 $finish;
    end
endmodule
