`timescale 1ns / 1ps
module forwarding_unit(
    input [4:0] EX_rs1,    
    input [4:0] EX_rs2,    
    input [4:0] MEM_rd,    
    input [4:0] WB_rd,     
    input MEM_RegWrite,    
    input WB_RegWrite,     

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    // Default: no forwarding
    forwardA = 2'b00;
    forwardB = 2'b00;

    // Check forwarding for rs1
    if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs1))
        forwardA = 2'b10;     // Forward from EX/MEM

    else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs1))
        forwardA = 2'b01;     // Forward from MEM/WB

    // Check forwarding for rs2
    if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs2))
        forwardB = 2'b10;     // Forward from EX/MEM

    else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs2))
        forwardB = 2'b01;     // Forward from MEM/WB
end

endmodule

