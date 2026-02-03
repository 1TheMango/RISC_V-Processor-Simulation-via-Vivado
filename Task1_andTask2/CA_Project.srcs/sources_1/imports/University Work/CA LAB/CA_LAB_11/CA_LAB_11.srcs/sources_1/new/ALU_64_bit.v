`timescale 1ns / 1ps

module ALU_64_bit_behavioral(
    input [63:0] a,   // Operand A
    input [63:0] b,   // Operand B
    input [3:0] op,   // Operation select
    output reg [63:0] res,  // Result
    output reg Zero         // Zero flag
);

always @(*) begin
    res  = 64'd0;
    Zero = 1'b0;

    case (op)

        4'b0000: res = a & b;        // AND
        4'b0001: res = a | b;        // OR
        4'b0010: res = a + b;        // ADD
        4'b0110: res = a - b;        // SUB
        4'b1100: res = ~(a | b);     // NOR

        // ======== BRANCH COMPARE OPERATIONS ========

        4'b1000: Zero = (a == b);                       // BEQ
        4'b1001: Zero = (a != b);                       // BNE
        4'b1010: Zero = ($signed(a) >= $signed(b));      // BGE
        4'b1011: Zero = ($signed(a) < $signed(b));       // BLT
        4'b1101: Zero = (a >= b);                        // BGEU
        4'b1110: Zero = (a < b);                        // BLTU
        
        default: begin
            res = 64'b0;
            Zero = 1'b0;
        end

    endcase

//    // Normal ALU ops update Zero via result
//    if(op == 4'b0000 || op == 4'b0001 || op == 4'b0010 || op == 4'b0110 || op == 4'b1100) begin
//        Zero = (res == 64'd0);
//    end
end

endmodule
