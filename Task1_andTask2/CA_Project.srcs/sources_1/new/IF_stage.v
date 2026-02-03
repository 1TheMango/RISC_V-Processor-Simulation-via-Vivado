`timescale 1ns / 1ps
module IF_Stage(
    input clk,
    input reset,
    input PCSrc,                // Branch control
    input [63:0] PC_Branch,     // Branch target address
    output [63:0] PC,           // Current PC
    output [63:0] PC_Plus4,     // PC + 4
    output [31:0] Instruction   // Fetched instruction
);
    
    // PC + 4 Adder
    assign PC_Plus4 = PC + 64'd4;
    
    // PC Mux (select next PC)
    wire [63:0] PC_Next;
    assign PC_Next = reset ? 64'b0 : (PCSrc ? PC_Branch : PC_Plus4);
    
    // Program Counter module instantiation
    Pipelined_Program_Counter pc(
        .clk(clk),
        .reset(reset),
        .PC_In(PC_Next),
        .PC_Out(PC)
    );
    
    // Instruction Memory
    Pipelined_Instruction_Memory imem(
        .inst_address(PC),
        .instruction(Instruction)
    );
    
endmodule