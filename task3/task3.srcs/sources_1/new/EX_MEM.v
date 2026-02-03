`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 09:20:30 PM
// Design Name: 
// Module Name: EX_MEM
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




module EX_MEM(                          
    input clk,  
    input flush_exmem,
    input [63:0] PC_with_immediate, 
    input [63:0] ALU_result,       
    input [63:0] WriteData,        
    input [3:0] func,     
    input [4:0] rd,   
    input Less,                    
    input Zero,
    input RegWrite,                
    input MemtoReg,                
    input Branch,                                   
    input MemWrite,                
    input MemRead, 
    output reg [63:0] PC_with_immediate_store,
    output reg [63:0] ALU_result_store,
    output reg [63:0] WriteData_store,
    output reg [3:0] func_store,       
    output reg [4:0] rd_store,    
    output reg Less_store, 
    output reg Zero_store,
    output reg RegWrite_store,       
    output reg MemtoReg_store,       
    output reg Branch_store,                    
    output reg MemWrite_store,       
    output reg MemRead_store 
);

always @(posedge clk) 
begin
    if (flush_exmem) begin
        PC_with_immediate_store <= 64'd0;
        ALU_result_store <= 64'd0;
        WriteData_store <= 64'd0;
        func_store <= 4'd0;       
        rd_store <= 5'd0;
        Less_store <= 1'd0;
        Zero_store <= 1'd0;
        RegWrite_store <= 1'd0;
        MemtoReg_store <= 1'd0;
        Branch_store <= 1'd0;
        MemWrite_store <= 1'd0;
        MemRead_store <= 1'd0;
    end 
    else begin
        PC_with_immediate_store <= PC_with_immediate;
        ALU_result_store <= ALU_result;
        WriteData_store <= WriteData;
        func_store <= func;       
        rd_store <= rd;
        Less_store <= Less;
        Zero_store <= Zero;
        RegWrite_store <= RegWrite;
        MemtoReg_store <= MemtoReg;
        Branch_store <= Branch;
        MemWrite_store <= MemWrite;
        MemRead_store <= MemRead;
    end
end
endmodule