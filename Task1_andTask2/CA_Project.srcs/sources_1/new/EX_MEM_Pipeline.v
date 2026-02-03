`timescale 1ns / 1ps
// ========================================================================
// FIXED: EX/MEM Register - Added Instruction_out reset
// ========================================================================
module EX_MEM_Register(
    input clk,
    input reset,
    
    // Control signals in
    input RegWrite_in,
    input MemtoReg_in,
    input MemRead_in,
    input MemWrite_in,
    input Branch_in,
    
    // Data in
    input [63:0] PC_Branch_in,
    input Zero_in,
    input [63:0] ALU_Result_in,
    input [63:0] WriteData_in,
    input [4:0] Rd_in,
    input [31:0] Instruction_in,
    
    // Control signals out
    output reg RegWrite_out,
    output reg MemtoReg_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    
    // Data out
    output reg [63:0] PC_Branch_out,
    output reg Zero_out,
    output reg [63:0] ALU_Result_out,
    output reg [63:0] WriteData_out,
    output reg [4:0] Rd_out,
    output reg [31:0] Instruction_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out <= 1'b0;
            PC_Branch_out <= 64'd0;
            Zero_out <= 1'b0;
            ALU_Result_out <= 64'd0;
            WriteData_out <= 64'd0;
            Rd_out <= 5'd0;
            Instruction_out <= 32'd0;  // FIXED: Added this line
        end
        else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            PC_Branch_out <= PC_Branch_in;
            Zero_out <= Zero_in;
            ALU_Result_out <= ALU_Result_in;
            WriteData_out <= WriteData_in;
            Rd_out <= Rd_in;
            Instruction_out <= Instruction_in;
        end
    end
endmodule
