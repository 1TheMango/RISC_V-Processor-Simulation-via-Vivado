`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 09:49:33 PM
// Design Name: 
// Module Name: mux_2x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_2x1(
    input [63:0] a,
    input [63:0] b,
    input sel,
    output [63:0] data_out
);
    assign data_out = sel ? b : a;
endmodule

