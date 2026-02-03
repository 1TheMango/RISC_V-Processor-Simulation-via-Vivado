`timescale 1ns / 1ps

module Mux(
    input [63:0] a,   // input1
    input [63:0] b,   // input2
    input s,          // selection bit
    output reg [63:0] o // output
);

always @ (a, b, s) begin
    case(s) // case statement
        1'b0: o = a;  // if s=0 --> o=b
        1'b1: o = b;  // if s=1 --> o=a
    endcase
end
endmodule

