`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 09:53:58 PM
// Design Name: 
// Module Name: inst_parser
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


module inst_parser(
    input [31:0] inst,
    output [2:0] func3,
    output [6:0] func7,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [6:0] opcode
);

    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign func3  = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign func7  = inst[31:25];

endmodule

