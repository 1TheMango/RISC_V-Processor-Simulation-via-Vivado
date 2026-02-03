`timescale 1ns / 1ps

module IM_2 (
    input [63:0] Instr_Addr,    // 64-bit instruction address input
    output [31:0] Instruction   // 32-bit instruction output
    );
   

      reg [7:0] Inst_Memory[127:0];  
      reg [31:0] instruction_in[31:0];  
   
   
    // Initializing the instruction memory with values
        integer i;
    initial begin
        // Load Base Address 0x100 into x21 
        instruction_in[0]  = 32'h10000a93; 
        
        // Load Array Size n=7 into x22 
        instruction_in[1]  = 32'h00700b13; 
        
        // Data Loading Section (Uses x21 as base)
        instruction_in[2]  = 32'h00700393; // x7 = 7
        instruction_in[3]  = 32'h007aa023; // sw x7, 0(x21)
        instruction_in[4]  = 32'h00600393; // x7 = 6
        instruction_in[5]  = 32'h007aa223; // sw x7, 4(x21)
        instruction_in[6]  = 32'h00500393; // x7 = 5
        instruction_in[7]  = 32'h007aa423; // sw x7, 8(x21)
        instruction_in[8]  = 32'h00400393; // x7 = 4
        instruction_in[9]  = 32'h007aa623; // sw x7, 12(x21)
        instruction_in[10] = 32'h00300393; // x7 = 3
        instruction_in[11] = 32'h007aa823; // sw x7, 16(x21)
        instruction_in[12] = 32'h00200393; // x7 = 2
        instruction_in[13] = 32'h007aaa23; // sw x7, 20(x21)
        instruction_in[14] = 32'h00900393; // x7 = 9
        instruction_in[15] = 32'h007aac23; // sw x7, 24(x21)
        
        // Sorting Logic
        instruction_in[16] = 32'h00000e13; // i = 0
        instruction_in[17] = 32'h00000e93; // j = 0
        instruction_in[18] = 32'h000e0e93; // j = i
        instruction_in[19] = 32'h002e1f13; // offset_i = i * 4
        
        // Calculate Addr[i]: x5 = x31 + x21 (Swapped logic: x5 is now temp dest)
        instruction_in[20] = 32'h015f0fb3; 
        
        instruction_in[21] = 32'h000fa103; // lw x2, 0(x31) -> Access using new temp x31 (Wait, line 20 calc put result in x31? No, original line 20 was add x31, x30, x5. My decoder mapped it to use x21 source)
        // Correction: Line 20 original: add x31, x30, x5. New: add x31, x30, x21.
        // Hex 015f0fb3: rs2=21 (10101), rs1=30, rd=31. Correct.
        
        instruction_in[22] = 32'h002e9f13; // offset_j = j * 4
        
        // Calculate Addr[j]: x5 = x30 + x21 (Swapped logic: dest is x5, source base is x21)
        instruction_in[23] = 32'h015f02b3; 
        
        instruction_in[24] = 32'h0002a183; // lw x3, 0(x5) (Loading from new temp x5)
        instruction_in[25] = 32'h0021d663; // bge x3, x2, skip
        instruction_in[26] = 32'h0022a023; // sw x2, 0(x5) (Store to new temp x5)
        instruction_in[27] = 32'h003fa023; // sw x3, 0(x31) (Store to x31 - unchanged temp)
        //skip:
        instruction_in[28] = 32'h001e8e93; // j++
        instruction_in[29] = 32'hfd6ecce3; // blt j, x22, loop (Check against Size x22)
        instruction_in[30] = 32'h001e0e13; // i++
        instruction_in[31] = 32'hfd6e46e3; // blt i, x22, loop (Check against Size x22)
       

        for(i = 0; i < 32; i = i + 1) begin
            Inst_Memory[i * 4] = instruction_in[i][7:0];
            Inst_Memory[i * 4 + 1] = instruction_in[i][15:8];
            Inst_Memory[i * 4 + 2] = instruction_in[i][23:16];
            Inst_Memory[i * 4 + 3] = instruction_in[i][31:24];
        end
    end
   
    // Read 4 consecutive bytes starting from Instr_Addr to form a 32-bit instruction
    assign Instruction[7:0] = Inst_Memory[Instr_Addr];        // Lower byte
    assign Instruction[15:8] = Inst_Memory[Instr_Addr + 1];   // Second byte
    assign Instruction[23:16] = Inst_Memory[Instr_Addr + 2];  // Third byte
    assign Instruction[31:24] = Inst_Memory[Instr_Addr + 3];  // Upper byte
   
endmodule