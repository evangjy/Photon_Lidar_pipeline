module photon_counter #(
    parameter integer WIDTH=32
)(
    input wire clk,
    input wire rst_n,
    input wire clear,
    input wire event_valid,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            count <= 0;
        else if(clear)
            count <= 0;
        else if(event_valid)
            count <= count + 1'b1;
    end
endmodule
