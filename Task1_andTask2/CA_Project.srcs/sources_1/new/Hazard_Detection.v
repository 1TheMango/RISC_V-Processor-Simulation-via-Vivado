`timescale 1ns / 1ps
module Hazard_Detection_Unit(
    input [4:0] IF_ID_Rs1,      // Rs1 from instruction in ID stage
    input [4:0] IF_ID_Rs2,      // Rs2 from instruction in ID stage
    input [4:0] ID_EX_Rd,       // Rd from instruction in EX stage
    input ID_EX_MemRead,        // Is EX instruction a load?
    
    output reg PCWrite,         // Enable PC update (0 = stall)
    output reg IF_ID_Write,     // Enable IF/ID register update (0 = stall)
    output reg ID_EX_Flush      // Insert bubble in ID/EX (1 = NOP)
);

    always @(*) begin
        // Default: normal operation (no stall)
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
        
        // Load-use hazard detection
        if (ID_EX_MemRead && 
            ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2)) &&
            (ID_EX_Rd != 5'd0))  // x0 is always 0, no hazard
        begin
            // STALL the pipeline
            PCWrite = 1'b0;      // Freeze PC
            IF_ID_Write = 1'b0;  // Freeze IF/ID register
            ID_EX_Flush = 1'b1;  // Insert NOP bubble in ID/EX
        end
    end

endmodule