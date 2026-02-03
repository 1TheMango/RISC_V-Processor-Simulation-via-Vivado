`timescale 1ns / 1ps

module ID_Stage(
    input clk,
    input reset,
    input [31:0] Instruction,   // From IF/ID register
    input [63:0] PC,            // From IF/ID register
    input [4:0] WB_Rd,          // Write back destination
    input [63:0] WB_Data,       // Write back data
    input WB_RegWrite,          // Write back control
    
    // Decoded outputs
    output [63:0] ReadData1,
    output [63:0] ReadData2,
    output [63:0] Imm,
    output [4:0] Rs1,
    output [4:0] Rs2,
    output [4:0] Rd,
    output [2:0] funct3,
    output [6:0] funct7,
    output [6:0] opcode,
    
    // Control signals
    output RegWrite,
    output MemtoReg,
    output MemRead,
    output MemWrite,
    output Branch,
    output ALUSrc,
    output [1:0] ALUOp
);
    // Instruction fields
    assign opcode = Instruction[6:0];
    assign Rd = Instruction[11:7];
    assign funct3 = Instruction[14:12];
    assign Rs1 = Instruction[19:15];
    assign Rs2 = Instruction[24:20];
    assign funct7 = Instruction[31:25];
    
    // Register File
    RegisterFile regfile(
        .clk(clk),
        .reset(reset),
        .RegWrite(WB_RegWrite),
        .RS1(Rs1),
        .RS2(Rs2),
        .RD(WB_Rd),
        .WriteData(WB_Data),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    // Immediate Generator
    pipelined_imm_gen immgen(
        .ins(Instruction),
        .imm_data(Imm)
    );
    
    // Control Unit
    Control_Unit control(
        .Opcode(opcode),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );
    
endmodule
