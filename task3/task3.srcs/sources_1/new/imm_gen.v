`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 09:59:28 PM
// Design Name: 
// Module Name: imm_data_gen
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


module imm_dat_gen(
    input [31:0] inst,
    output reg [63:0] imm
);
    wire [1:0] sel;
    assign sel = inst[6:5];

    always @* begin
        if (sel == 2'b00)
            imm[11:0] = inst[31:20];
        else if (sel == 2'b01)
            imm[11:0] = {inst[31:25], inst[11:7]};
        else if (sel == 2'b11)
            imm[11:0] = {inst[31], inst[7], inst[30:25], inst[11:8]};

        if (imm[11] == 0)
            imm[63:12] = 0;
        else if (imm[11] == 1)
            imm[63:12] = 52'b1111111111111111111111111111111111111111111111111111;
    end
endmodule

