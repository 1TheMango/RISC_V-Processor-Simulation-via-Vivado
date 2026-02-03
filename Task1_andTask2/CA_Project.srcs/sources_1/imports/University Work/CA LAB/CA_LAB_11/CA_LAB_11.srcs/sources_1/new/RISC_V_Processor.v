`timescale 1ns / 1ps
module RISC_V_Processor(
    input clk,
    input reset
    );
    
    // instantiating modules here:
    wire [63:0] PC_In;
    wire [63:0] PC_Out;
    wire [31:0] instruction;
    wire [6:0] op_code, funct_7;
    wire[4:0] rd, rs1, rs2;
    wire[2:0] funct_3;
    wire [63:0] imm_data;
    wire [1:0] ALUOp;
    wire Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite;
    wire [63:0] ReadData1, ReadData2;
    wire [63:0] WriteData;
    wire [3:0] operation;
    wire [63:0] b, Mem_Addr;
    wire zero;
    wire [63:0] Read_Data;
    wire [63:0] Adder_out, M3_0;
    
    Program_Counter PC(clk, reset, PC_In, PC_Out);
    
    //Adding PC_OUT + 4 (Base condition) 
    Adder ADD1(PC_Out, 64'd4, M3_0);
    
    Instruction_Memory IM(.inst_address(PC_Out), .instruction(instruction));
    
    instruction_parser IP(.ins(instruction), .op(op_code), .rd(rd), .f3(funct_3), .rs1(rs1), .rs2(rs2), .f7(funct_7));
    
    Control_Unit CU(.Opcode(op_code), .ALUOp(ALUOp), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
    
    RegisterFile RF(.clk(clk), .reset(reset), .RS1(rs1), .RS2(rs2), .RD(rd), .WriteData(WriteData), .RegWrite(RegWrite), .ReadData1(ReadData1), .ReadData2(ReadData2));
    
    imm_gen IG(.ins(instruction), .imm_data(imm_data));
    
    Mux M1(ReadData2, imm_data, ALUSrc, b);
    
    wire [63:0] Adder_b = imm_data << 1;
    
    //Next Branch address
    Adder ADD2(PC_Out, Adder_b, Adder_out);
    
    ALU_Control AC(
.ALUOp(ALUOp),
 .funct3(funct_3), .funct7(funct_7), .Operation(operation)
);
    
    ALU_64_bit_behavioral ALU_64(ReadData1, b, operation, Mem_Addr, zero);
    
    //Next instruction loaded into PC_In, or branch target if the branch condition is true
    Mux M2(M3_0, Adder_out, Branch & zero, PC_In);
    
    Data_Memory DM(Mem_Addr, ReadData2, clk, MemWrite, MemRead, Read_Data);

    // Selects between ALU result (Mem_Addr) and memory output (Read_Data) based on MemtoReg control signal to determine the value written back to the register file
    Mux M3(Mem_Addr, Read_Data, MemtoReg, WriteData);
    
endmodule
