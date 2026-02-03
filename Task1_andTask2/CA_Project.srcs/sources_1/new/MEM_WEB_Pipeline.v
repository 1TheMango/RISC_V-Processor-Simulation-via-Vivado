`timescale 1ns / 1ps
// ========================================================================
// FIXED: MEM/WB Register - Added Instruction_out reset
// ========================================================================
module MEM_WB_Register(
    input clk,
    input reset,
    
    // ===== Control Signals In =====
    input RegWrite_in,
    input MemtoReg_in,
    
    // ===== Data In =====
    input [63:0] ReadData_in,      // Data from memory
    input [63:0] ALU_Result_in,    // ALU result
    input [4:0] Rd_in,             // Destination register
    input [31:0] Instruction_in,
    
    // ===== Control Signals Out =====
    output reg RegWrite_out,
    output reg MemtoReg_out,
    
    // ===== Data Out =====
    output reg [63:0] ReadData_out,
    output reg [63:0] ALU_Result_out,
    output reg [4:0] Rd_out,
    output reg [31:0] Instruction_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear everything on reset
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            ReadData_out <= 64'd0;
            ALU_Result_out <= 64'd0;
            Rd_out <= 5'd0;
            Instruction_out <= 32'd0;  // FIXED: Added this line
        end
        else begin
            // Normal operation
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            ReadData_out <= ReadData_in;
            ALU_Result_out <= ALU_Result_in;
            Rd_out <= Rd_in;
            Instruction_out <= Instruction_in;
        end
    end
endmodule