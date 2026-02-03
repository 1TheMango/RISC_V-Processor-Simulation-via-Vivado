`timescale 1ns / 1ps
module Control_Unit(
    input [6:0] Opcode,
    output reg [1:0] ALUOp,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
    );
    always @(*) begin
    // Manually assigning values accoring to convention.
    case(Opcode[6:4])
        // I type instruction with opcode[6:4] as 000
        3'd0: begin
            ALUSrc = 1'b1;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            Branch = 1'b0;
            ALUOp[1:0] = 2'b0; 
        end
        // I type instruction with opcode[6:4] as 001
        3'd1: begin
            ALUSrc = 1'b1;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            Branch = 1'b0;
            ALUOp[1:0] = 2'b0; 
        end
        // S type instruction with opcode[6:4] as 001
        3'd2: begin
            ALUSrc = 1'b1;
            MemtoReg = 1'bX;
            RegWrite = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            Branch = 1'b0;
            ALUOp[1:0] = 2'd0; 
        end
        // R type instruction with opcode[6:4] as 001
        3'd3: begin
            ALUSrc = 1'b0;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            Branch = 1'b0;
            ALUOp[1:0] = 2'b10; 
        end
        // SB type instruction with opcode[6:4] as 001
        3'd6: begin
            ALUSrc = 1'b0;
            MemtoReg = 1'bX;
            RegWrite = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            Branch = 1'b1;
            ALUOp[1:0] = 2'd01; 
        end
    endcase
    end 
    
endmodule
