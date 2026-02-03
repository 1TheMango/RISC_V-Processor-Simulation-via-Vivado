`timescale 1ns / 1ps
// ========================================================================
// ID/EX Register - No changes needed (already correct)
// ========================================================================
module ID_EX_Register(
    input clk,
    input reset,
    
    // ===== Control Signals In =====
    input RegWrite_in,
    input MemtoReg_in,
    input MemRead_in,
    input MemWrite_in,
    input Branch_in,
    input ALUSrc_in,
    input [1:0] ALUOp_in,
    
    // ===== Data In =====
    input [63:0] PC_in,
    input [63:0] ReadData1_in,
    input [63:0] ReadData2_in,
    input [63:0] Imm_in,
    input [4:0] Rs1_in,
    input [4:0] Rs2_in,
    input [4:0] Rd_in,
    input [2:0] funct3_in,
    input [6:0] funct7_in,
    input [31:0] Instruction_in,
    
    // ===== Control Signals Out =====
    output reg RegWrite_out,
    output reg MemtoReg_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUOp_out,
    
    // ===== Data Out =====
    output reg [63:0] PC_out,
    output reg [63:0] ReadData1_out,
    output reg [63:0] ReadData2_out,
    output reg [63:0] Imm_out,
    output reg [4:0] Rs1_out,
    output reg [4:0] Rs2_out,
    output reg [4:0] Rd_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,
    output reg [31:0] Instruction_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear control signals on reset
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out <= 1'b0;
            ALUSrc_out <= 1'b0;
            ALUOp_out <= 2'b00;
            
            // Clear data
            PC_out <= 64'd0;
            ReadData1_out <= 64'd0;
            ReadData2_out <= 64'd0;
            Imm_out <= 64'd0;
            Rs1_out <= 5'd0;
            Rs2_out <= 5'd0;
            Rd_out <= 5'd0;
            funct3_out <= 3'd0;
            funct7_out <= 7'd0;
            Instruction_out <= 32'd0;
        end
        else begin
            // Normal operation
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            ALUSrc_out <= ALUSrc_in;
            ALUOp_out <= ALUOp_in;
            
            PC_out <= PC_in;
            ReadData1_out <= ReadData1_in;
            ReadData2_out <= ReadData2_in;
            Imm_out <= Imm_in;
            Rs1_out <= Rs1_in;
            Rs2_out <= Rs2_in;
            Rd_out <= Rd_in;
            funct3_out <= funct3_in;
            funct7_out <= funct7_in;
            Instruction_out <= Instruction_in;
        end
    end
endmodule