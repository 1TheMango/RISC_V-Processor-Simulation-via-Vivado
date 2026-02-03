`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 09:32:57 PM
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB(
    input clk,                                      
    input [63:0] ReadData,          
    input [63:0] ALU_result,        
    input [4:0] rd,    
    input RegWrite,                 
    input MemtoReg,       
    output reg [63:0] ReadData_store, 
    output reg [63:0] ALU_result_store,
    output reg [4:0] rd_store,
    output reg RegWrite_store,        
    output reg MemtoReg_store
);
always @(posedge clk) 
begin
        ReadData_store <= ReadData;
        ALU_result_store <= ALU_result;
        rd_store <= rd;
        RegWrite_store <= RegWrite;
        MemtoReg_store <= MemtoReg;
end
endmodule
