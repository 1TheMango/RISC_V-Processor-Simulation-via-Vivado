`timescale 1ns / 1ps

module Pipelined_Processor(
    input clk,
    input reset
);
    //========================================================================
    // IF Stage Wires
    //========================================================================
    wire [63:0] PC, PC_Plus4, PC_Branch;
    wire [31:0] Instruction;
    wire PCSrc;  // Branch control (from MEM stage)
    
    //========================================================================
    // IF/ID Pipeline Register Outputs
    //========================================================================
    wire [63:0] IF_ID_PC;
    wire [31:0] IF_ID_Instruction, ID_EX_Instruction, EX_MEM_Instruction, MEM_WB_Instruction;
    
    //========================================================================
    // ID Stage Wires
    //========================================================================
    wire [63:0] ID_ReadData1, ID_ReadData2, ID_Imm;
    wire [4:0] ID_Rs1, ID_Rs2, ID_Rd;
    wire [2:0] ID_funct3;
    wire [6:0] ID_funct7, ID_opcode;
    
    // ID Stage Control Signals
    wire ID_RegWrite;
    wire ID_MemtoReg;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire ID_Branch;
    wire ID_ALUSrc;
    wire [1:0] ID_ALUOp;
    
    //========================================================================
    // ID/EX Pipeline Register Outputs
    //========================================================================
    // Control signals
    wire ID_EX_RegWrite;
    wire ID_EX_MemtoReg;
    wire ID_EX_MemRead;
    wire ID_EX_MemWrite;
    wire ID_EX_Branch;
    wire ID_EX_ALUSrc;
    wire [1:0] ID_EX_ALUOp;
    
    // Data
    wire [63:0] ID_EX_PC;
    wire [63:0] ID_EX_ReadData1;
    wire [63:0] ID_EX_ReadData2;
    wire [63:0] ID_EX_Imm;
    wire [4:0] ID_EX_Rs1;
    wire [4:0] ID_EX_Rs2;
    wire [4:0] ID_EX_Rd;
    wire [2:0] ID_EX_funct3;
    wire [6:0] ID_EX_funct7;
    
    //========================================================================
    // EX Stage Wires
    //========================================================================
    wire [63:0] EX_ALU_Result;
    wire EX_Zero;
    wire [63:0] EX_WriteData;  // For store instructions
    wire [63:0] EX_PC_Branch;
    
    //========================================================================
    // EX/MEM Pipeline Register Outputs
    //========================================================================
    // Control signals
    wire EX_MEM_RegWrite;
    wire EX_MEM_MemtoReg;
    wire EX_MEM_MemRead;
    wire EX_MEM_MemWrite;
    wire EX_MEM_Branch;
    
    // Data
    wire [63:0] EX_MEM_PC_Branch;
    wire EX_MEM_Zero;
    wire [63:0] EX_MEM_ALU_Result;
    wire [63:0] EX_MEM_WriteData;
    wire [4:0] EX_MEM_Rd;
    
    //========================================================================
    // MEM Stage Wires
    //========================================================================
    wire [63:0] MEM_ReadData;
    
    // Branch decision (computed in MEM stage)
    assign PCSrc = EX_MEM_Branch & EX_MEM_Zero;
    
    //========================================================================
    // MEM/WB Pipeline Register Outputs
    //========================================================================
    // Control signals
    wire MEM_WB_RegWrite;
    wire MEM_WB_MemtoReg;
    
    // Data
    wire [63:0] MEM_WB_ReadData;
    wire [63:0] MEM_WB_ALU_Result;
    wire [4:0] MEM_WB_Rd;
    
    //========================================================================
    // WB Stage Wires
    //========================================================================
    wire [63:0] WB_WriteData;
    

    
    //========================================================================
    // STAGE INSTANTIATIONS
    //========================================================================
    
    // ========== IF Stage ==========
    IF_Stage if_stage(
        .clk(clk),
        .reset(reset),
        .PCSrc(PCSrc),
        .PC_Branch(EX_MEM_PC_Branch),
        .PC(PC),
        .PC_Plus4(PC_Plus4),
        .Instruction(Instruction)
    );
    
    // ========== IF/ID Pipeline Register ==========
    IF_ID_Register if_id_reg(
        .clk(clk),
        .reset(reset),
        .PC_in(PC),
        .PC_out(IF_ID_PC),
        .Instruction_in(Instruction),
        .Instruction_out(IF_ID_Instruction)
    );
    
    // ========== ID Stage ==========
    ID_Stage id_stage(
        .clk(clk),
        .reset(reset),
        .Instruction(IF_ID_Instruction),
        .PC(IF_ID_PC),
        .WB_Rd(MEM_WB_Rd),
        .WB_Data(WB_WriteData),
        .WB_RegWrite(MEM_WB_RegWrite),
        // Outputs
        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2),
        .Imm(ID_Imm),
        .Rs1(ID_Rs1),
        .Rs2(ID_Rs2),
        .Rd(ID_Rd),
        .funct3(ID_funct3),
        .funct7(ID_funct7),
        .opcode(ID_opcode),
        // Control signals
        .RegWrite(ID_RegWrite),
        .MemtoReg(ID_MemtoReg),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .Branch(ID_Branch),
        .ALUSrc(ID_ALUSrc),
        .ALUOp(ID_ALUOp)
    );
    
    // ========== Hazard Detection Unit ==========
    // Removed - no hazard detection in this version
    
    // ========== ID/EX Pipeline Register ==========
    ID_EX_Register id_ex_reg(
        .clk(clk),
        .reset(reset),
        // Control signals in
        .RegWrite_in(ID_RegWrite),
        .MemtoReg_in(ID_MemtoReg),
        .MemRead_in(ID_MemRead),
        .MemWrite_in(ID_MemWrite),
        .Branch_in(ID_Branch),
        .ALUSrc_in(ID_ALUSrc),
        .ALUOp_in(ID_ALUOp),
        // Data in
        .PC_in(IF_ID_PC),
        .ReadData1_in(ID_ReadData1),
        .ReadData2_in(ID_ReadData2),
        .Imm_in(ID_Imm),
        .Rs1_in(ID_Rs1),
        .Rs2_in(ID_Rs2),
        .Rd_in(ID_Rd),
        .funct3_in(ID_funct3),
        .funct7_in(ID_funct7),
        // Control signals out
        .RegWrite_out(ID_EX_RegWrite),
        .MemtoReg_out(ID_EX_MemtoReg),
        .MemRead_out(ID_EX_MemRead),
        .MemWrite_out(ID_EX_MemWrite),
        .Branch_out(ID_EX_Branch),
        .ALUSrc_out(ID_EX_ALUSrc),
        .ALUOp_out(ID_EX_ALUOp),
        // Data out
        .PC_out(ID_EX_PC),
        .ReadData1_out(ID_EX_ReadData1),
        .ReadData2_out(ID_EX_ReadData2),
        .Imm_out(ID_EX_Imm),
        .Rs1_out(ID_EX_Rs1),
        .Rs2_out(ID_EX_Rs2),
        .Rd_out(ID_EX_Rd),
        .funct3_out(ID_EX_funct3),
        .funct7_out(ID_EX_funct7),
        .Instruction_in(IF_ID_Instruction),
        .Instruction_out(ID_EX_Instruction)
    );
    
    // ========== Forwarding Unit ==========
    // Removed - no forwarding in this version
    
    // ========== EX Stage ==========
    EX_Stage ex_stage(
        .PC(ID_EX_PC),
        .ReadData1(ID_EX_ReadData1),
        .ReadData2(ID_EX_ReadData2),
        .Imm(ID_EX_Imm),
        .funct3(ID_EX_funct3),
        .funct7(ID_EX_funct7),
        .ALUOp(ID_EX_ALUOp),
        .ALUSrc(ID_EX_ALUSrc),
        .Instruction(ID_EX_Instruction),
        // Outputs
        .ALU_Result(EX_ALU_Result),
        .Zero(EX_Zero),
        .WriteData(EX_WriteData),
        .PC_Branch(EX_PC_Branch)
    );
    
    // ========== EX/MEM Pipeline Register ==========
    EX_MEM_Register ex_mem_reg(
        .clk(clk),
        .reset(reset),
        // Control signals in
        .RegWrite_in(ID_EX_RegWrite),
        .MemtoReg_in(ID_EX_MemtoReg),
        .MemRead_in(ID_EX_MemRead),
        .MemWrite_in(ID_EX_MemWrite),
        .Branch_in(ID_EX_Branch),
        // Data in
        .PC_Branch_in(EX_PC_Branch),
        .Zero_in(EX_Zero),
        .ALU_Result_in(EX_ALU_Result),
        .WriteData_in(EX_WriteData),
        .Rd_in(ID_EX_Rd),
        // Control signals out
        .RegWrite_out(EX_MEM_RegWrite),
        .MemtoReg_out(EX_MEM_MemtoReg),
        .MemRead_out(EX_MEM_MemRead),
        .MemWrite_out(EX_MEM_MemWrite),
        .Branch_out(EX_MEM_Branch),
        // Data out
        .PC_Branch_out(EX_MEM_PC_Branch),
        .Zero_out(EX_MEM_Zero),
        .ALU_Result_out(EX_MEM_ALU_Result),
        .WriteData_out(EX_MEM_WriteData),
        .Rd_out(EX_MEM_Rd),
        .Instruction_in(ID_EX_Instruction),
        .Instruction_out(EX_MEM_Instruction)
    );
    
    // ========== MEM Stage ==========
    MEM_Stage mem_stage(
        .clk(clk),
        .MemRead(EX_MEM_MemRead),
        .MemWrite(EX_MEM_MemWrite),
        .Address(EX_MEM_ALU_Result),
        .WriteData(EX_MEM_WriteData),
        .Instruction(EX_MEM_Instruction),
        .ReadData(MEM_ReadData)
    );
    
    // ========== MEM/WB Pipeline Register ==========
    MEM_WB_Register mem_wb_reg(
        .clk(clk),
        .reset(reset),
        // Control signals in
        .RegWrite_in(EX_MEM_RegWrite),
        .MemtoReg_in(EX_MEM_MemtoReg),
        // Data in
        .ReadData_in(MEM_ReadData),
        .ALU_Result_in(EX_MEM_ALU_Result),
        .Rd_in(EX_MEM_Rd),
        // Control signals out
        .RegWrite_out(MEM_WB_RegWrite),
        .MemtoReg_out(MEM_WB_MemtoReg),
        // Data out
        .ReadData_out(MEM_WB_ReadData),
        .ALU_Result_out(MEM_WB_ALU_Result),
        .Rd_out(MEM_WB_Rd),
        .Instruction_in(EX_MEM_Instruction),
        .Instruction_out(MEM_WB_Instruction)
    );
    
    // ========== WB Stage ==========
    WB_Stage wb_stage(
        .MemtoReg(MEM_WB_MemtoReg),
        .ALU_Result(MEM_WB_ALU_Result),
        .ReadData(MEM_WB_ReadData),
        .Instruction(MEM_WB_Instruction),
        .WriteData(WB_WriteData)
    );
    
endmodule