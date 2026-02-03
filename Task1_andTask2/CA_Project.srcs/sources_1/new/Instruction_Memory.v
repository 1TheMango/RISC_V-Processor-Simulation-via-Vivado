`timescale 1ns / 1ps

module Instruction_Memory(
    input [63:0] inst_address, // 64-bit instruction address
    output reg [31:0] instruction // 32-bit fetched instruction
    );
    reg [7:0] inst_memory [512:0]; // 32 bytes of instruction memory
    // Initialize memory with machine instructions
  initial
	begin
        
		//1. li x2, 0x200 # Stack pointer
		inst_memory[0]=8'b00010011;
		inst_memory[1]=8'b00000001;
		inst_memory[2]=8'b00000000;
		inst_memory[3]=8'b00100000;
		//2. addi x2, x2, -36 # Initializing space for stack
		inst_memory[4]=8'b00010011;
		inst_memory[5]=8'b00000001;
		inst_memory[6]=8'b11000001;
		inst_memory[7]=8'b11111101;
		//3. sw x10, 0(x2) # Storing the parameters
		inst_memory[8]=8'b00100011;
		inst_memory[9]=8'b00100000;
		inst_memory[10]=8'b10100001;
		inst_memory[11]=8'b00000000;
		//4. sw x11, 4(x2) # Storing the parameters
		inst_memory[12]=8'b00100011;
		inst_memory[13]=8'b00100010;
		inst_memory[14]=8'b10110001;
		inst_memory[15]=8'b0;
		//5. li x8, 0 # i = 0
		inst_memory[16]=8'b00010011;
		inst_memory[17]=8'b0100;
		inst_memory[18]=8'b0;
		inst_memory[19]=8'b0;
		//6. sw x8, 8(x2) # Storing i in stack
		inst_memory[20]=8'b00100011;
		inst_memory[21]=8'b00100100;
		inst_memory[22]=8'b10000001;
		inst_memory[23]=8'b0;
		//7. beq x10 x0 exit # if *a = 0, exit
		inst_memory[24]=8'b01100011;
		inst_memory[25]=8'b00001110;
		inst_memory[26]=8'b00000101;
		inst_memory[27]=8'b0110;
		//8. beq x11 x0 exit # if len = 0, exit
		inst_memory[28]=8'b01100011;
		inst_memory[29]=8'b10001100;
		inst_memory[30]=8'b00000101;
		inst_memory[31]=8'b0110;
		//9. add x9, x8, x0 # j = i
		inst_memory[32]=8'b10110011;
		inst_memory[33]=8'b00000100;
		inst_memory[34]=8'b0100;
		inst_memory[35]=8'b0;
		//10. sw x9, 12(x2) # Storing j in stack
		inst_memory[36]=8'b00100011;
		inst_memory[37]=8'b00100110;
		inst_memory[38]=8'b10010001;
		inst_memory[39]=8'b00000000;
		//11. bge x8 x11 exit # if i >= len, exit
		inst_memory[40]=8'b01100011;
		inst_memory[41]=8'b01010110;
		inst_memory[42]=8'b10110100;
		inst_memory[43]=8'b00000110;
		//12. bge x9 x11 i_increament # if j >= len, i_increament
		inst_memory[44]=8'b01100011;
		inst_memory[45]=8'b11010000;
		inst_memory[46]=8'b10110100;
		inst_memory[47]=8'b00000110;
		//13. addi x18 x8 0
		inst_memory[48]=8'b00010011;
		inst_memory[49]=8'b00001001;
		inst_memory[50]=8'b00000100;
		inst_memory[51]=8'b00000000;
		//14. add x18 x18 x18
		inst_memory[52]=8'b00110011;
		inst_memory[53]=8'b00001001;
		inst_memory[54]=8'b00101001;
		inst_memory[55]=8'b00000001;
		//15. add x18 x18 x18
		inst_memory[56]=8'b00110011;
		inst_memory[57]=8'b00001001;
		inst_memory[58]=8'b00101001;
		inst_memory[59]=8'b00000001;
		//16. add x18, x18, x10
		inst_memory[60]=8'b00110011;
		inst_memory[61]=8'b00001001;
		inst_memory[62]=8'b10101001;
		inst_memory[63]=8'b00000000;
		//17. sw x18, 16(x2) # storing address of a[i] in stack
		inst_memory[64]=8'b00100011;
		inst_memory[65]=8'b00101000;
		inst_memory[66]=8'b00100001;
		inst_memory[67]=8'b0001;
		//18. addi x19 x9 0
		inst_memory[68] = 8'h93;
        inst_memory[69] = 8'h89;
        inst_memory[70] = 8'h04;
        inst_memory[71] = 8'h00;
        //19. add x18 x18 x18
        inst_memory[72] = 8'hB3;
        inst_memory[73] = 8'h89;
        inst_memory[74] = 8'h39;
        inst_memory[75] = 8'h01;    
        //20. add x18 x18 x18
        inst_memory[76] = 8'hB3;
        inst_memory[77] = 8'h89;
        inst_memory[78] = 8'h39;
        inst_memory[79] = 8'h01;
		//21. add x19 x19 x10
		inst_memory[80]=8'b10110011;
		inst_memory[81]=8'b10001001;
		inst_memory[82]=8'b10101001;
		inst_memory[83]=8'b0;
		//22. sw x19, 20(x2) # storing address of a[j] in stack
		inst_memory[84]=8'b00100011;
		inst_memory[85]=8'b00101010;
		inst_memory[86]=8'b00110001;
		inst_memory[87]=8'b0001;
		//23. lw x20, 0(x18) # x20 = value of a[i]
		inst_memory[88]=8'b00000011;
		inst_memory[89]=8'b00101010;
		inst_memory[90]=8'b1001;
		inst_memory[91]=8'b0;
		//24. sw x20, 24(x2) # storing value of a[i] in stack
		inst_memory[92]=8'b00100011;
		inst_memory[93]=8'b00101100;
		inst_memory[94]=8'b01000001;
		inst_memory[95]=8'b0001;
		//25. lw x21, 0(x19) # x21 = value of a[j]
		inst_memory[96]=8'b10000011;
		inst_memory[97]=8'b10101010;
		inst_memory[98]=8'b1001;
		inst_memory[99]=8'b0;
		//26. sw x21, 28(x2) # storing value of a[j] in stack
		inst_memory[100]=8'b00100011;
		inst_memory[101]=8'b00101110;
		inst_memory[102]=8'b01010001;
		inst_memory[103]=8'b0001;
		//27. addi x9 x9 1 # j++
		inst_memory[104]=8'b10010011;
		inst_memory[105]=8'b10000100;
		inst_memory[106]=8'b00010100;
		inst_memory[107]=8'b0;
		//28. blt x20 x21 inner_loop # if a[i] >= a[j], go to inner_loop
		inst_memory[108]=8'b11100011;
		inst_memory[109]=8'b01000000;
		inst_memory[110]=8'b01011010;
		inst_memory[111]=8'b11111101;
		//29. add x22 x20 x0 # temp = a[i]
		inst_memory[112]=8'b00110011;
		inst_memory[113]=8'b00001011;
		inst_memory[114]=8'b1010;
		inst_memory[115]=8'b0;
		//30. sw x22, 32(x2) # Storing temp in stack
		inst_memory[116]=8'b00100011;
		inst_memory[117]=8'b00100000;
		inst_memory[118]=8'b01100001;
		inst_memory[119]=8'b0011;
		//31. add x20 x21 x0 # a[i] = a[j]
		inst_memory[120]=8'b00110011;
		inst_memory[121]=8'b10001010;
		inst_memory[122]=8'b1010;
		inst_memory[123]=8'b00000000;
		//32. add x21 x22 x0 # a[j] = temp
		inst_memory[124]=8'b10110011;
		inst_memory[125]=8'b00001010;
		inst_memory[126]=8'b1011;
		inst_memory[127]=8'b0100;
		//33. sw x20, 0(x18) # storing new value of a[i] in address of a[i]
		inst_memory[128]=8'b00100011;
		inst_memory[129]=8'b00100000;
		inst_memory[130]=8'b01001001;
		inst_memory[131]=8'b0001;
		//34. sw x21, 0(x19) # storing new value of a[j] in address of a[j]
		inst_memory[132]=8'b00100011;
		inst_memory[133]=8'b10100000;
		inst_memory[134]=8'b01011001;
		inst_memory[135]=8'b0001;
		//35. beq x0, x0 inner_loop # go to inner_loop
		inst_memory[136]=8'b11100011;
		inst_memory[137]=8'b00000010;
		inst_memory[138]=8'b00000000;
		inst_memory[139]=8'b11111010;
		// i_icreament
		//36. addi x8, x8, 1 # i++
		inst_memory[140]=8'b00010011;
		inst_memory[141]=8'b00000100;
		inst_memory[142]=8'b00010100;
		inst_memory[143]=8'b000;
		//37. beq x0, x0 outer_loop # go to outer_loop
		inst_memory[144]=8'b11100011;
		inst_memory[145]=8'b00001000;
		inst_memory[146]=8'b00000000;
		inst_memory[147]=8'b11111000;
		//38. addi x2, x2, 36 # resizing stack
		inst_memory[148]=8'b00010011;
		inst_memory[149]=8'b00000001;
		inst_memory[150]=8'b01000001;
		inst_memory[151]=8'b00000010;
		
	end

    // Fetch 32-bit instruction based on address
    always @(inst_address[63:0]) begin
        instruction = {inst_memory[3 + inst_address], inst_memory[2 + inst_address], inst_memory[1 + inst_address], inst_memory[0 + inst_address]};
        end
endmodule
