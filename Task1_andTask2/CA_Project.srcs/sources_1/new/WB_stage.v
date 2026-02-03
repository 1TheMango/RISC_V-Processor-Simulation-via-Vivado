`timescale 1ns / 1ps

module WB_Stage(
    input MemtoReg,
    input [63:0] ALU_Result,    // From MEM/WB register
    input [63:0] ReadData,      // From MEM/WB register
    // Instruction address
    input [31:0] Instruction, // MEM/WEB register
    
    output [63:0] WriteData     // Data to write to register file
);
    // Mux to select between ALU result and memory data
    assign WriteData = MemtoReg ? ReadData : ALU_Result;
endmodule
