`timescale 1ns / 1ps


module Data_Memory(
input [63:0] Mem_Addr, // Memory address
input [63:0] Write_Data, // Data to write
input clk, // Clock signal
input MemWrite,  // Write enable
input MemRead, // Read enable
output reg [63:0] Read_Data // Data read from memory
);
integer i;
reg [7:0] data_memory [511:0]; // 64-byte data memory
// Initialize memory with sample data
    initial begin
        for(i = 0; i < 512; i = i + 1)
            data_memory[i] = 0;
    end
    initial begin
        data_memory[256] = 8'd7;
        data_memory[260] = 8'd6;
        data_memory[264] = 8'd5;      
        data_memory[268] = 8'd4;
        data_memory[272] = 8'd3;
        data_memory[276] = 8'd2;
        data_memory[280] = 8'd1;
        data_memory[284] = 8'd0;
    end
// Memory operations
always @(posedge clk) begin
    if (MemWrite) begin
//                    data_memory[Mem_Addr+7] <= Write_Data[63:56];
//                    data_memory[Mem_Addr+6] <= Write_Data[55:48];
//                    data_memory[Mem_Addr+5] <= Write_Data[47:40];
//                    data_memory[Mem_Addr+4] <= Write_Data[39:32];
                    data_memory[Mem_Addr+3] <= Write_Data[31:24];
                    data_memory[Mem_Addr+2] <= Write_Data[23:16];
                    data_memory[Mem_Addr+1] <= Write_Data[15:8];
                    data_memory[Mem_Addr+0] <= Write_Data[7:0];
    end
end
// READ operation (combinational)
always @(*) begin
    if (MemRead) begin
//        Read_Data[63:56] = data_memory[Mem_Addr + 7];
//        Read_Data[55:48] = data_memory[Mem_Addr + 6];
//        Read_Data[47:40] = data_memory[Mem_Addr + 5];
//        Read_Data[39:32] = data_memory[Mem_Addr + 4];
        Read_Data[63:32] = 32'b0;
        Read_Data[31:24] = data_memory[Mem_Addr + 3];
        Read_Data[23:16] = data_memory[Mem_Addr + 2];
        Read_Data[15:8]  = data_memory[Mem_Addr + 1];
        Read_Data[7:0]   = data_memory[Mem_Addr + 0];
    end else begin
        Read_Data = 64'b0;
    end
end
endmodule
