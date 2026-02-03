`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 03:14:35 PM
// Design Name: 
// Module Name: Data_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_Memory(
    input [63:0] Mem_Addr,     // Memory address input
    input [63:0] Write_Data,    // Data to write into memory
    input clk,                  // Clock signal for synchronous operations
    input MemWrite,             // Control signal to enable writing to memory
    input MemRead,              // Control signal to enable reading from memory
    output reg [63:0] Read_Data // Output data read from memory
);

// 64-byte memory array (8-bit wide, 64 elements)
reg [7:0] DataMemory[1023:0];

// Initialize memory with values 0 to 63 during simulation start
integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1)
        DataMemory[i] = 8'd0;
end

// Always block to read data when MemRead is high
always @(*) begin
    if (MemRead) begin
        Read_Data[7:0]   = DataMemory[Mem_Addr];
        Read_Data[15:8]  = DataMemory[Mem_Addr+1];
        Read_Data[23:16] = DataMemory[Mem_Addr+2];
        Read_Data[31:24] = DataMemory[Mem_Addr+3];
//        Read_Data[39:32] = DataMemory[Mem_Addr+4];
//        Read_Data[47:40] = DataMemory[Mem_Addr+5];
//        Read_Data[55:48] = DataMemory[Mem_Addr+6];
//        Read_Data[63:56] = DataMemory[Mem_Addr+7];
        Read_Data[63:32] = 0;
    end
end

// Always block to write data when MemWrite is high (on clock edge)
always @(posedge clk) begin
    if (MemWrite) begin
        DataMemory[Mem_Addr]   = Write_Data[7:0];
        DataMemory[Mem_Addr+1] = Write_Data[15:8];
        DataMemory[Mem_Addr+2] = Write_Data[23:16];
        DataMemory[Mem_Addr+3] = Write_Data[31:24];

    end
end

endmodule

