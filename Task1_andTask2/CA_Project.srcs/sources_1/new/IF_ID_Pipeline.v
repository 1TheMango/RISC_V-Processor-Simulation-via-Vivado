`timescale 1ns / 1ps

// ========================================================================
// FIXED: IF/ID Register - Changed to asynchronous reset
// ========================================================================
module IF_ID_Register(
    input clk,
    input reset,
    input [63:0] PC_in,
    input [31:0] Instruction_in,
    output reg [63:0] PC_out,
    output reg [31:0] Instruction_out
);
    always @(posedge clk or posedge reset) begin  // FIXED: Added "or posedge reset"
        if (reset) begin
            PC_out <= 64'd0;
//            Instruction_out <= 32'h00000013;  // NOP (addi x0, x0, 0)
        end
        else begin
            PC_out <= PC_in;
            Instruction_out <= Instruction_in;
        end
    end
endmodule