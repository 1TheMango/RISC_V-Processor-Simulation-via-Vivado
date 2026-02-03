`timescale 1ns / 1ps


module MEM_Stage(
    input clk,
    input MemRead,
    input MemWrite,
    input [63:0] Address,       // ALU Result (address)
    input [63:0] WriteData,     // Data to write
    // Instruction address
    input [31:0] Instruction, // From EX/MEM register
    
    output [63:0] ReadData      // Data read from memory
);
    Data_Memory dmem(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Mem_Addr(Address),
        .Write_Data(WriteData),
        .Read_Data(ReadData)
    );
endmodule
