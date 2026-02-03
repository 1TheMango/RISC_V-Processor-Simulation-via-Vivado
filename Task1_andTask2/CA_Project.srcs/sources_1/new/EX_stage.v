`timescale 1ns / 1ps


module EX_Stage(
    input [63:0] PC,            // From ID/EX register
    input [63:0] ReadData1,     // From ID/EX register
    input [63:0] ReadData2,     // From ID/EX register
    input [63:0] Imm,           // From ID/EX register
    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] ALUOp,
    input ALUSrc,
    // Instruction address
    input [31:0] Instruction, // From ID/EX register
    
    // (No forwarding) inputs removed
    
    // Outputs
    output [63:0] ALU_Result,
    output Zero,
    output [63:0] WriteData,    // For store instructions
    output [63:0] PC_Branch
    
);
    // ALU inputs (no forwarding): use register values directly
    wire [63:0] ALU_Input_A;
    assign ALU_Input_A = ReadData1;

    // ALU Source Mux (immediate or register)
    wire [63:0] ALU_Input_B;
    assign ALU_Input_B = ALUSrc ? Imm : ReadData2;
    
    // ALU Control
    wire [3:0] ALU_Operation;
    ALU_Control alu_ctrl(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .Operation(ALU_Operation)
    );
    
    // ALU
    ALU_64_bit_behavioral alu(
        .a(ALU_Input_A),
        .b(ALU_Input_B),
        .op(ALU_Operation),
        .res(ALU_Result),
        .Zero(Zero)
    );
    
    wire [63:0] new_imm = Imm << 1;
    // Branch target address
    
    Adder ADD2(PC, new_imm, PC_Branch);
    
    // Write data for store (no forwarding)
    assign WriteData = ReadData2;
    
endmodule