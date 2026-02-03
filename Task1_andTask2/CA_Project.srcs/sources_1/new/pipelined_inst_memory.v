`timescale 1ns / 1ps

module Pipelined_Instruction_Memory(
    input [63:0] inst_address, // 64-bit instruction address
    output reg [31:0] instruction // 32-bit fetched instruction
);
    reg [7:0] inst_memory [1024:0];
    
    initial begin
        //1. li x2, 0x200 # Stack pointer
        inst_memory[0]=8'b00010011;
        inst_memory[1]=8'b00000001;
        inst_memory[2]=8'b00000000;
        inst_memory[3]=8'b00100000;
        // li x3, 3
        //NOP (add x0, x0, x0) - after li x2
        inst_memory[4]=8'h33;
        inst_memory[5]=8'h00;
        inst_memory[6]=8'h00;
        inst_memory[7]=8'h00;
        // addi x10, x0, 256
        inst_memory[8]=8'h13;
        inst_memory[9]=8'h05;
        inst_memory[10]=8'h00;
        inst_memory[11]=8'h10;
        //2. addi x2, x2, -36 # Initializing space for stack
        inst_memory[12]=8'b00010011;
        inst_memory[13]=8'b00000001;
        inst_memory[14]=8'b11000001;
        inst_memory[15]=8'b11111101;
        //NOP (add x0, x0, x0) - after addi x2
        inst_memory[16]=8'h33;
        inst_memory[17]=8'h00;
        inst_memory[18]=8'h00;
        inst_memory[19]=8'h00;
        //NOP (add x0, x0, x0) - after addi x2
        inst_memory[20]=8'h33;
        inst_memory[21]=8'h00;
        inst_memory[22]=8'h00;
        inst_memory[23]=8'h00;
        //3. sw x10, 0(x2) # Storing the parameters
        inst_memory[24]=8'b00100011;
        inst_memory[25]=8'b00100000;
        inst_memory[26]=8'b10100001;
        inst_memory[27]=8'b00000000;
        //4. sw x11, 4(x2) # Storing the parameters
        inst_memory[28]=8'b00100011;
        inst_memory[29]=8'b00100010;
        inst_memory[30]=8'b10110001;
        inst_memory[31]=8'b00000000;
        //5. li x8, 0 # i = 0
        inst_memory[32]=8'b00010011;
        inst_memory[33]=8'b01000000;
        inst_memory[34]=8'b00000000;
        inst_memory[35]=8'b00000000;
        //NOP (add x0, x0, x0) - after li x8
        inst_memory[36]=8'h33;
        inst_memory[37]=8'h00;
        inst_memory[38]=8'h00;
        inst_memory[39]=8'h00;
        //NOP (add x0, x0, x0) - after li x8
        inst_memory[40]=8'h33;
        inst_memory[41]=8'h00;
        inst_memory[42]=8'h00;
        inst_memory[43]=8'h00;
        //6. sw x8, 8(x2) # Storing i in stack
        inst_memory[44]=8'b00100011;
        inst_memory[45]=8'b00100100;
        inst_memory[46]=8'b10000001;
        inst_memory[47]=8'b00000000;
        
        //7. beq x10 x0 exit # if *a = 0, exit (PC=48, Target=76, Offset==28)
        inst_memory[48]=8'b01100011;
        inst_memory[49]=8'b00001110;
        inst_memory[50]=8'b00000000;
        inst_memory[51]=8'b00000000;
        //NOP (add x0, x0, x0) - after beq
        inst_memory[52]=8'h33;
        inst_memory[53]=8'h00;
        inst_memory[54]=8'h00;
        inst_memory[55]=8'h00;
        //NOP (add x0, x0, x0) - after beq
        inst_memory[56]=8'h33;
        inst_memory[57]=8'h00;
        inst_memory[58]=8'h00;
        inst_memory[59]=8'h00;
        
        //NOP (add x0, x0, x0) - after beq
        inst_memory[60]=8'h33;
        inst_memory[61]=8'h00;
        inst_memory[62]=8'h00;
        inst_memory[63]=8'h00;
        
        //9. add x9, x8, x0 # j = i (outer_loop starts here at PC=80)
        inst_memory[64]=8'b10110011;
        inst_memory[65]=8'b00000100;
        inst_memory[66]=8'b00000100;
        inst_memory[67]=8'b00000000;
        
        //13. addi x18 x8 0 (inner_loop starts here at PC=128)
        inst_memory[68]=8'b00010011;
        inst_memory[69]=8'b00001001;
        inst_memory[70]=8'b00000100;
        inst_memory[71]=8'b00000000;
        
        //23. lw x20, 0(x18) # x20 = value of a[i]  ---- LOAD HAZARD ----
        inst_memory[72]=8'b00000011;
        inst_memory[73]=8'b00101010;
        inst_memory[74]=8'b00001001;
        inst_memory[75]=8'b00000000;
        
        //8. addi x2, x2, 36 # resizing stack (exit label at PC=372)
        inst_memory[76]=8'b00010011;
        inst_memory[77]=8'b00000001;
        inst_memory[78]=8'b01000001;
        inst_memory[79]=8'b00000010;
    end

    // FIXED: Fetch 32-bit instruction using proper byte addressing
    always @(*) begin
        instruction = {inst_memory[inst_address + 3], 
                       inst_memory[inst_address + 2], 
                       inst_memory[inst_address + 1], 
                       inst_memory[inst_address + 0]};
    end
    
endmodule