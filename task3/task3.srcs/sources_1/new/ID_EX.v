`timescale 1ns / 1ps

module ID_EX_2 (
    input clk, 
    input flush,                           
    input [63:0] PC_addr,           
    input [63:0] read_data1,                    
    input [63:0] read_data2,                    
    input [63:0] immediate,              
    input [3:0] func,                  
    input [4:0] rs1,                
    input [4:0] rs2,                   
    input [4:0] rd,                    
    input MemtoReg,                      
    input RegWrite,                      
    input Branch,                         
    input MemWrite,                       
    input MemRead,                       
    input ALUSrc,                        
    input [1:0]  ALU_op,                         
    output reg [63:0] PC_addr_store,   
    output reg [63:0] read_data1_store,             
    output reg [63:0] read_data2_store,            
    output reg [63:0] immediate_store,       
    output reg [3:0] func_store,          
    output reg [4:0] rs1_store,       
    output reg [4:0] rs2_store,            
    output reg [4:0] rd_store,            
    output reg MemtoReg_store,               
    output reg RegWrite_store,               
    output reg Branch_store,                
    output reg MemWrite_store,              
    output reg MemRead_store,                
    output reg ALUSrc_store,                 
    output reg [1:0] ALU_op_store                  
);

always @(posedge clk) begin
    if (flush) begin
            // Flush control signals to insert NOP
            MemtoReg_store   <= 1'b0;
            RegWrite_store   <= 1'b0;
            Branch_store     <= 1'b0;
            MemWrite_store   <= 1'b0;
            MemRead_store    <= 1'b0;
            ALUSrc_store     <= 1'b0;
            ALU_op_store     <= 2'b00;
            PC_addr_store    <= 64'd0;
            read_data1_store <= 64'd0;
            read_data2_store <= 64'd0;
            immediate_store  <= 64'd0;
            func_store       <= 4'd0;
            rs1_store        <= 5'd0;
            rs2_store        <= 5'd0;
            rd_store         <= 5'd0;
        end
    else begin
            PC_addr_store <= PC_addr;
            read_data1_store <= read_data1;
            read_data2_store <= read_data2;
            immediate_store <= immediate;
            func_store <= func;
            rs1_store <= rs1;
            rs2_store <= rs2;
            rd_store <= rd;
            MemtoReg_store <= MemtoReg;
            RegWrite_store <= RegWrite;
            Branch_store <= Branch;
            MemWrite_store <= MemWrite;
            MemRead_store <= MemRead;
            ALUSrc_store <= ALUSrc;
            ALU_op_store <= ALU_op;
        end
end
endmodule