`timescale 1ns/1ps
module tb_synchronizer;
    reg clk=0, rst_n=0, async_in=0;
    wire sync_out;

    always #5 clk = ~clk;

    synchronizer dut(
        .clk(clk), .rst_n(rst_n),
        .async_in(async_in), .sync_out(sync_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_synchronizer);

        #17 rst_n=1;
        #13 async_in=1;
        #8  async_in=0;
        #30 async_in=1;
        #7  async_in=0;
        #40 $finish;
    end
endmodule
