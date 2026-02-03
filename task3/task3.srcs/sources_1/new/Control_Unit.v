`timescale 1ns / 1ps

module Control_Unit(
    input [6:0] Opcode,          
    output reg [1:0] ALUOp,       // 2-bit ALU operation control signal
    output reg Branch,            // Branch control signal
    output reg MemRead,           // Memory Read control signal
    output reg MemtoReg,          // Memory to Register control signal
    output reg MemWrite,          // Memory Write control signal
    output reg ALUSrc,            
    output reg RegWrite          
    );
    
    always @(*) begin
        if(Opcode == 7'b0110011) begin 
            ALUOp <= 2'b10;
            Branch <= 1'b0;
            MemRead <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0; 
            ALUSrc <= 1'b0;
            RegWrite <= 1'b1;
        end
        
        else if(Opcode == 7'b0000011) begin // I-type instruction (load)
            ALUOp <= 2'b00;
            Branch <= 1'b0;
            MemRead <= 1'b1;
            MemtoReg <= 1'b1;
            MemWrite <= 1'b0; 
            ALUSrc <= 1'b1;
            RegWrite <= 1'b1;
        end
        
        else if(Opcode == 7'b0100011) begin // S-type instruction (store)
            ALUOp <= 2'b00;
            Branch <= 1'b0;
            MemRead <= 1'b0;
            MemtoReg <= 1'b0; // Don't care
            MemWrite <= 1'b1; 
            ALUSrc <= 1'b1;
            RegWrite <= 1'b0;
        end
        
        else if(Opcode == 7'b1100011) begin // SB-type instruction (branch equal)
            ALUOp = 2'b01;
            Branch = 1'b1;
            MemRead = 1'b0;
            MemtoReg = 1'bx; 
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
        end
        
        else if(Opcode == 7'b0010011) begin // I-type instruction (addi)
            ALUOp = 2'b10;
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            MemWrite = 1'b0; 
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
        end
        
        else begin // Default case
            ALUOp = 2'b00;
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            MemWrite = 1'b0; 
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
        end
    end
endmodule
