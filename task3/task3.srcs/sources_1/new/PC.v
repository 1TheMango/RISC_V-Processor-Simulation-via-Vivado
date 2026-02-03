`timescale 1ns / 1ps

module PC_2 (
    input clk,
    input reset,
    input [63:0] PC_In,
    input PC_Write,
    output reg [63:0] PC_Out
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_Out <= 0;
        else if (PC_Write)
            PC_Out <= PC_In;
    end
    
endmodule
