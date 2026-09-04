`timescale 1ns/1ps
module tb_afe_event_detector;
    reg clk=0, rst_n=0;
    reg [11:0] adc_sample=12'd2048;
    wire photon_event;
    wire [11:0] sample_level;

    afe_event_detector #(.ADC_WIDTH(12),.BASELINE(2048),.THRESHOLD(2300),.HOLD_OFF_CYCLES(8)) dut(
        .clk(clk), .rst_n(rst_n), .adc_sample(adc_sample),
        .photon_event(photon_event), .sample_level(sample_level));

    always #5 clk = ~clk;

    task sample(input integer v, input integer n);
        integer i;
        begin
            adc_sample = v;
            for (i=0;i<n;i=i+1) @(posedge clk);
        end
    endtask

    always @(posedge clk)
        if (photon_event) $display("AFE EVENT @ %0t ns, ADC=%0d", $time, sample_level);

    initial begin
        $dumpfile("afe.vcd"); $dumpvars(0,tb_afe_event_detector);
        #20 rst_n=1;
        sample(2048,10);
        sample(2450,1); sample(2500,3); sample(2048,10);
        sample(2600,1); sample(2500,2); sample(2048,12);
        sample(2400,1); sample(2048,5);
        #20 $finish;
    end
endmodule
