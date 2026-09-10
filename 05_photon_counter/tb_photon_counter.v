`timescale 1ns/1ps
module tb_photon_counter;
    reg clk=0,rst_n=0,clear=0,event_valid=0;
    wire [31:0] count;
    always #5 clk=~clk;

    photon_counter dut(
        .clk(clk),.rst_n(rst_n),.clear(clear),
        .event_valid(event_valid),.count(count)
    );

    task photon;
        begin
            @(negedge clk); event_valid=1;
            @(negedge clk); event_valid=0;
        end
    endtask

    initial begin
        #12 rst_n=1;
        photon; photon; photon;
        #20 $display("count=%0d",count);
        clear=1; #10 clear=0;
        photon; photon;
        #20 $display("count=%0d",count);
        #20 $finish;
    end
endmodule
