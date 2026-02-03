`timescale 1ns / 1ps

module RegisterFile(
    input clk,               // Clock signal
    input reset,             // Reset signal
    input [4:0] RS1,         // Address of source register 1
    input [4:0] RS2,         // Address of source register 2
    input [4:0] RD,          // Address of destination register
    input [63:0] WriteData,  // Data to write
    input RegWrite,          // Control signal for writing
    output reg [63:0] ReadData1, // Output data from register 1
    output reg [63:0] ReadData2  // Output data from register 2
);
  
    reg [63:0] registers [0:31];  // 32 registers, each 64 bits wide
    initial begin
        registers[0]  = 64'd0;
        registers[1]  = 64'd0;
        registers[2]  = 64'd0;
        registers[3]  = 64'd0;
        registers[4]  = 64'd0;
        registers[5]  = 64'd0;
        registers[6]  = 64'd0;
        registers[7]  = 64'd0;
        registers[8]  = 64'd0;
        registers[9]  = 64'd0;
        registers[10] = 64'd256;
        registers[11] = 64'd7;
        registers[12] = 64'd0;
        registers[13] = 64'd0;
        registers[14] = 64'd0;
        registers[15] = 64'd0;
        registers[16] = 64'd0;
        registers[17] = 64'd0;
        registers[18] = 64'd0;
        registers[19] = 64'd0;
        registers[20] = 64'd0;
        registers[21] = 64'd0;
        registers[22] = 64'd0;
        registers[23] = 64'd0;
        registers[24] = 64'd0;
        registers[25] = 64'd0;
        registers[26] = 64'd0;
        registers[27] = 64'd0;
        registers[28] = 64'd0;
        registers[29] = 64'd0;
        registers[30] = 64'd0;
        registers[31] = 64'd0;
    end
    // Write and reset logic
    always @(posedge clk) begin
        if (reset) begin
            ReadData1 = 64'b0;
            ReadData2 = 64'b0;
        end 
        else if (RegWrite & RD != 0) begin
            registers[RD] = WriteData;
        end
    end
    always @(*)
        begin
            ReadData1 = registers[RS1];
            ReadData2 = registers[RS2];
        end
endmodule
