`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2025 04:02:44 PM
// Design Name: 
// Module Name: ALU_64_bit
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
//////////////////////////////////////////////////////////////////////////////////


module ALU_64_bit(
    input [63:0] a,         // A
    input [63:0] b,         // B
    input Cin,       // Carry-in
    input [3:0] ALUOp, //ALU Operation
    output Cout, ZERO,     // Carry-out and ZERO
    output Less,
    output reg [63:0] Result    // Result
    );
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    assign Less = (signed_a < signed_b);


    wire [63:0] a_bar, b_bar, and_r, or_r, xor_r, add, sub; //wires for various operations
    
    //assigning A not and B not
    assign a_bar = ~a;
    assign b_bar = ~b;
    
    
    //Calculating results
    assign and_r = a & b;
    assign or_r = a | b;
    assign xor_r = a ^ b;
    
    assign add = a + b + Cin;
    assign sub = a - b + Cin;
    
    assign ZERO = (a-b == 64'b0);
    
    assign Cout = (a[63] & b[63]) | ((a[63] | b[63]) & add[63]);
    
    //Figuring out which result to output
    always @(*) begin
        case (ALUOp)
            4'b0000: Result = and_r;     // AND
            4'b0001: Result = or_r;      // OR
            4'b0010: Result = add;       // ADD
            4'b0011: Result = sub;       // SUB
            4'b0100: Result = xor_r;     // XOR
            4'b0101: Result = a << b; // SLLI
            default: Result = 64'b0;     // Default to 0 if no operation matches
        endcase
    end
endmodule
