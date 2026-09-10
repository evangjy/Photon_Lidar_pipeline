module time_gate #(
    parameter integer WIDTH=32,
    parameter integer START_BIN=80,
    parameter integer END_BIN=160
)(
    input  wire [WIDTH-1:0] timestamp,
    input  wire timestamp_valid,
    output wire event_valid
);
    assign event_valid = timestamp_valid &&
                         (timestamp >= START_BIN) &&
                         (timestamp <= END_BIN);
endmodule
