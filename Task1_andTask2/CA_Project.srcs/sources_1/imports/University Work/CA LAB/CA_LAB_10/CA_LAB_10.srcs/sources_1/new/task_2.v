module ALU_Control(
    input [1:0] ALUOp,
    input [2:0] funct3,      // funct3 field from instruction [14:12]
    input [6:0] funct7,      // funct7 field from instruction [31:25]
    output reg [3:0] Operation
);
    
    always @(*) begin
        case(ALUOp)
            2'b00: begin
                // Load/Store instructions (LD, SD, etc.)
                // Use ADD for address calculation (base + offset)
                Operation = 4'b0010;  // ADD
            end
            
            2'b01: begin
                // Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                case(funct3)
                    3'b000: Operation = 4'b1000;  // BEQ
                    3'b001: Operation = 4'b1001;  // BNE
                    3'b100: Operation = 4'b1011;  // BLT (signed <)
                    3'b101: Operation = 4'b1010;  // BGE (signed >=)
                    3'b110: Operation = 4'b1110;  // BLTU (unsigned <)
                    3'b111: Operation = 4'b1101;  // BGEU (unsigned >=)
                    default: Operation = 4'b0000;
                endcase
            end
            
            2'b10: begin
                // R-type and I-type arithmetic/logical instructions
                case(funct3)
                    3'b000: begin
                        // ADD (R-type/I-type) or SUB (R-type only)
                        if (funct7 == 7'b0100000)
                            Operation = 4'b0110;  // SUB (R-type: sub)
                        else
                            Operation = 4'b0010;  // ADD (R-type: add, I-type: addi)
                    end
                    3'b111: Operation = 4'b0000;  // AND (R-type: and, I-type: andi)
                    3'b110: Operation = 4'b0001;  // OR (R-type: or, I-type: ori)
                    // Add more as needed:
                    // 3'b100: XOR
                    // 3'b001: SLL (shift left logical)
                    // 3'b101: SRL/SRA (shift right)
                    default: Operation = 4'b0000;
                endcase
            end
            
            default: Operation = 4'b0000;
        endcase
    end
    
endmodule