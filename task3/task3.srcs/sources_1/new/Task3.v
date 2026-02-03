`timescale 1ns / 1ps

module task_3 (
    input clk, 
    input reset,
    output [63:0] debug_MEMWB_writeData
);


    // --- Stage 1: Instruction Fetch (IF) Wires ---
    wire [63:0] if_pc_current;          // Current Program Counter value
    wire [63:0] if_pc_next;             // Next PC value (either PC+4 or Branch Target)
    wire [63:0] if_pc_plus_4;           // PC + 4
    wire [31:0] if_instruction_raw;     // Raw instruction fetched from IM
    wire pc_stall_enable;               // Control signal to freeze PC
    
    // --- Stage 2: Decode (ID) Wires ---
    wire [63:0] id_pc_addr;             // PC passed to ID stage
    wire [31:0] id_instruction;         // Instruction passed to ID stage
    wire stall_ifid_pipe;               // Stall signal for IF/ID register
    wire flush_ifid_pipe;               // Flush signal for IF/ID register (on branch)
    
    // Parsed Instruction Fields
    wire [6:0] id_opcode;
    wire [4:0] id_rd, id_rs1, id_rs2;
    wire [2:0] id_funct3;
    wire [6:0] id_funct7;
    wire [63:0] id_imm_extended;

    // Register File Outputs
    wire [63:0] id_reg_data_1;
    wire [63:0] id_reg_data_2;

    // Control Unit Signals (Generated in ID)
    wire ctrl_branch, ctrl_mem_read, ctrl_mem_to_reg, ctrl_mem_write;
    wire ctrl_alu_src, ctrl_reg_write;
    wire [1:0] ctrl_alu_op;
    
    // Hazard Handling
    wire flush_idex_pipe;               // Flush ID/EX register (hazards)
    wire flush_idex_combined;           // OR logic for flushing (Branch OR Hazard)
    wire is_opcode_load_or_imm;         // Used for hazard detection logic

    // --- Stage 3: Execute (EX) Wires ---
    // Pipeline Register Outputs
    wire [63:0] ex_pc_addr;
    wire [63:0] ex_reg_data_1;
    wire [63:0] ex_reg_data_2;
    wire [63:0] ex_imm_data;
    wire [3:0]  ex_funct_combined;      // {funct7[6], funct3}
    wire [4:0]  ex_rs1, ex_rs2, ex_rd;
    
    // EX Control Signals
    wire ex_ctrl_mem_to_reg, ex_ctrl_reg_write, ex_ctrl_branch;
    wire ex_ctrl_mem_write, ex_ctrl_mem_read, ex_ctrl_alu_src;
    wire [1:0] ex_ctrl_alu_op;

    // ALU Connections
    wire [3:0] alu_operation_code;      // Final operation code for ALU
    reg  [63:0] alu_operand_A;          // First ALU input (after forwarding)
    reg  [63:0] alu_operand_B;          // Second ALU input (after forwarding)
    wire [63:0] alu_mux_B_out;          // Output of Mux deciding between Reg2 or Immediate
    wire [63:0] ex_alu_result;          // The calculation result
    wire alu_flag_zero, alu_flag_less, alu_flag_cout;

    // Forwarding
    wire [1:0] fwd_ctrl_A;              // Forwarding selector for Input A
    wire [1:0] fwd_ctrl_B;              // Forwarding selector for Input B

    // --- Stage 4: Memory (MEM) Wires ---
    wire flush_exmem_pipe;              // Flush signal for EX/MEM pipe
    // Pipeline Register Outputs
    wire [63:0] mem_pc_branch_target;   // Calculated PC + Offset
    wire [63:0] mem_alu_result;
    wire [63:0] mem_write_data_store;   // Data to be written to memory
    wire [4:0]  mem_rd;
    wire [3:0]  mem_funct_debug;        // Passed down for branch logic check
    
    // MEM Control Signals & Flags
    wire mem_ctrl_reg_write, mem_ctrl_mem_to_reg, mem_ctrl_branch;
    wire mem_ctrl_mem_write, mem_ctrl_mem_read;
    wire mem_flag_less, mem_flag_zero;
    
    // Branch Logic
    wire branch_decision_taken;         // Final High/Low signal to take the branch
    wire [63:0] branch_target_pc;       // The address to jump to

    // Data Memory Output
    wire [63:0] mem_read_data_out;      // Data read from RAM

    // --- Stage 5: Writeback (WB) Wires ---
    wire [63:0] wb_mem_read_data;
    wire [63:0] wb_alu_result;
    wire [4:0]  wb_rd;
    wire wb_ctrl_reg_write;
    wire wb_ctrl_mem_to_reg;
    
    wire [63:0] wb_final_write_data;    // Data written back to Register File

    // =========================================================================
    //                          STAGE 1: FETCH (IF)
    // =========================================================================

    // 1. Program Counter Register
    PC_2 pc_module (
        .clk(clk),
        .reset(reset),
        .PC_In(if_pc_next),             // Next address to load
        .PC_Write(~pc_stall_enable),    // Stall if hazard detected
        .PC_Out(if_pc_current)
    );

    // 2. PC Adder (PC + 4)
    adder pc_adder_4 (
        .a(if_pc_current),
        .b(64'd4),
        .out(if_pc_plus_4)
    );

    // 3. Instruction Memory
    IM_2 instr_mem (
        .Instr_Addr(if_pc_current),
        .Instruction(if_instruction_raw)
    );

    // Logic: If a branch is taken later in the pipeline, we must flush the current fetch
    assign flush_ifid_pipe = branch_decision_taken;

    // 4. IF/ID Pipeline Register
    IF_ID_2 if_id_reg (
        .clk(clk),
        .PC_addr(if_pc_current),
        .Inst(if_instruction_raw),
        .IF_ID_Write(~stall_ifid_pipe), // Freeze pipe if hazard stall
        .flush(flush_ifid_pipe),        // Clear instruction if branching
        .PC_addr_store(id_pc_addr),
        .Inst_store(id_instruction)
    );

    // =========================================================================
    //                          STAGE 2: DECODE (ID)
    // =========================================================================

    // 1. Instruction Parser (Splits 32-bit inst into fields)
    inst_parser instr_decoder (
        .inst(id_instruction),
        .func3(id_funct3),
        .func7(id_funct7),
        .opcode(id_opcode),
        .rd(id_rd),
        .rs1(id_rs1),
        .rs2(id_rs2)
    );

    // Check Opcode type for Hazard Unit (Detects Loads/Immediate/Jumps)
    assign is_opcode_load_or_imm = (id_opcode == 7'b0010011) || 
                                   (id_opcode == 7'b0000011) || 
                                   (id_opcode == 7'b1100111) || 
                                   (id_opcode == 7'b1110011);

    // 2. Hazard Detection Unit
    // Detects if a Load instruction is followed by a use of that data
    Hazard_Detection_Unit hazard_unit (
        .reset(reset),
        .id_ex_memread(ex_ctrl_mem_read),       // Check if previous inst is reading mem
        .id_ex_rd(ex_rd),                       // Check dest of previous inst
        .if_id_rs1(id_rs1),
        .if_id_rs2(is_opcode_load_or_imm ? 5'bX : id_rs2), // Ignore rs2 for immediates
        .stall_pc(pc_stall_enable),
        .stall_if_id(stall_ifid_pipe),
        .flush_id_ex(flush_idex_pipe)
    );

    // 3. Control Unit (Main Decoder)
    Control_Unit main_control (
        .Opcode(id_opcode),
        .ALUOp(ctrl_alu_op),
        .Branch(ctrl_branch), 
        .MemRead(ctrl_mem_read), 
        .MemtoReg(ctrl_mem_to_reg),
        .MemWrite(ctrl_mem_write), 
        .ALUSrc(ctrl_alu_src),
        .RegWrite(ctrl_reg_write)
    );

    // 4. Register File
    registerFile reg_file (
        .WriteData(^wb_final_write_data === 1'bx ? 63'd0 : wb_final_write_data),
        .RS1(id_rs1),
        .RS2(id_rs2),
        .RD(^wb_rd === 1'bx ? 5'd0 : wb_rd),
        .RegWrite(^wb_ctrl_reg_write === 1'bx ? 1'b0 : wb_ctrl_reg_write),
        .clk(clk),
        .reset(reset),
        .ReadData1(id_reg_data_1),
        .ReadData2(id_reg_data_2)
    );

    // 5. Immediate Generator
    imm_dat_gen imm_extender (
        .inst(id_instruction),
        .imm(id_imm_extended)
    );

    // Prepare funct code for ALU Control
    wire [3:0] id_funct_combined = {id_funct7[6], id_funct3};
    
    // Flush ID/EX if hazard detected OR branch taken
    assign flush_idex_combined = branch_decision_taken | flush_idex_pipe;

    // 6. ID/EX Pipeline Register
    ID_EX_2 id_ex_reg (
        .clk(clk),
        .flush(flush_idex_combined),
        .PC_addr(id_pc_addr),
        .read_data1(id_reg_data_1),
        .read_data2(id_reg_data_2),
        .immediate(id_imm_extended),
        .func(id_funct_combined),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd(id_rd),
        // Control Signals In
        .MemtoReg(ctrl_mem_to_reg),
        .RegWrite(ctrl_reg_write),
        .Branch(ctrl_branch),
        .MemWrite(ctrl_mem_write),
        .MemRead(ctrl_mem_read),
        .ALUSrc(ctrl_alu_src),
        .ALU_op(ctrl_alu_op),
        // Signals Out (to EX stage)
        .PC_addr_store(ex_pc_addr),
        .read_data1_store(ex_reg_data_1),
        .read_data2_store(ex_reg_data_2),
        .immediate_store(ex_imm_data),
        .func_store(ex_funct_combined),
        .rs1_store(ex_rs1),
        .rs2_store(ex_rs2),
        .rd_store(ex_rd),
        .MemtoReg_store(ex_ctrl_mem_to_reg),
        .RegWrite_store(ex_ctrl_reg_write),
        .Branch_store(ex_ctrl_branch),
        .MemWrite_store(ex_ctrl_mem_write),
        .MemRead_store(ex_ctrl_mem_read),
        .ALUSrc_store(ex_ctrl_alu_src),
        .ALU_op_store(ex_ctrl_alu_op)
    );

    // =========================================================================
    //                          STAGE 3: EXECUTE (EX)
    // =========================================================================
    
    
    // 1. ALU Control Unit
    ALU_Control alu_decoder (
        .ALUOp(ex_ctrl_alu_op),
        .Funct(ex_funct_combined),
        .Operation(alu_operation_code)
    );

    // 2. Forwarding Unit
    // Resolves data dependencies (e.g., using result from MEM or WB stage immediately)
    Forwarding_Unit fwd_unit (
        .id_ex_rs1(ex_rs1),
        .id_ex_rs2(ex_rs2),
        .ex_mem_rd(mem_rd),
        .ex_mem_regwrite(mem_ctrl_reg_write),
        .mem_wb_rd(wb_rd),
        .mem_wb_regwrite(wb_ctrl_reg_write),
        .forward_a(fwd_ctrl_A),
        .forward_b(fwd_ctrl_B)
    );

    // 3. ALU Input Multiplexers (Forwarding Logic)
    always @(*) begin
        // Select Input A
        case (fwd_ctrl_A)
            2'b00: alu_operand_A = ex_reg_data_1;          // No forwarding
            2'b10: alu_operand_A = mem_alu_result;         // Forward from MEM stage
            2'b01: alu_operand_A = wb_final_write_data;    // Forward from WB stage
            default: alu_operand_A = ex_reg_data_1;
        endcase

        // Select Input B (Before Immediate Mux)
        case (fwd_ctrl_B)
            2'b00: alu_operand_B = ex_reg_data_2;
            2'b10: alu_operand_B = mem_alu_result;
            2'b01: alu_operand_B = wb_final_write_data;
            default: alu_operand_B = ex_reg_data_2;
        endcase
    end

    // 4. ALU Source Mux (Register vs Immediate)
    mux_2x1 alu_src_mux (
        .a(alu_operand_B),
        .b(ex_imm_data),
        .sel(ex_ctrl_alu_src),
        .data_out(alu_mux_B_out)
    );

    // 5. Main ALU
    ALU_64_bit main_alu (
        .a(alu_operand_A),
        .b(alu_mux_B_out),
        .Cin(1'b0), 
        .ALUOp(alu_operation_code),
        .Cout(alu_flag_cout), 
        .ZERO(alu_flag_zero), 
        .Less(alu_flag_less), 
        .Result(ex_alu_result)
    );

    // Flush EX/MEM pipe if branch taken
    assign flush_exmem_pipe = branch_decision_taken;

    // 6. EX/MEM Pipeline Register
    EX_MEM ex_mem_reg (
        .clk(clk),
        .flush_exmem(flush_exmem_pipe),
        // Calculate Branch Target: PC + (Imm << 1)
        .PC_with_immediate(ex_pc_addr + (ex_imm_data << 1)), 
        .ALU_result(ex_alu_result),
        .WriteData(alu_operand_B),      // Data to store in memory (forwarded reg2)
        .func(ex_funct_combined),
        .rd(ex_rd),
        .Less(alu_flag_less),
        .Zero(alu_flag_zero),
        .RegWrite(ex_ctrl_reg_write),
        .MemtoReg(ex_ctrl_mem_to_reg),
        .Branch(ex_ctrl_branch),
        .MemWrite(ex_ctrl_mem_write),
        .MemRead(ex_ctrl_mem_read),
        // Signals Out (to MEM stage)
        .PC_with_immediate_store(mem_pc_branch_target), 
        .ALU_result_store(mem_alu_result),
        .WriteData_store(mem_write_data_store),
        .func_store(mem_funct_debug),       
        .rd_store(mem_rd),
        .Less_store(mem_flag_less),      
        .Zero_store(mem_flag_zero),      
        .RegWrite_store(mem_ctrl_reg_write),
        .MemtoReg_store(mem_ctrl_mem_to_reg),
        .Branch_store(mem_ctrl_branch),  
        .MemWrite_store(mem_ctrl_mem_write),
        .MemRead_store(mem_ctrl_mem_read)
    );

    // =========================================================================
    //                          STAGE 4: MEMORY (MEM)
    // =========================================================================

    

    // 1. Branch Logic Evaluation
    // Checks funct3 code to determine branch condition (beq, bne, blt, bge)
    assign branch_decision_taken = 
          (mem_funct_debug[2:0] == 3'b000) ? (mem_ctrl_branch && mem_flag_zero) :       // beq
          (mem_funct_debug[2:0] == 3'b001) ? (mem_ctrl_branch && !mem_flag_zero) :      // bne
          (mem_funct_debug[2:0] == 3'b100) ? (mem_ctrl_branch && mem_flag_less) :       // blt
          (mem_funct_debug[2:0] == 3'b101) ? (mem_ctrl_branch && !mem_flag_less) :      // bge
          0;

    // 2. PC Mux (Next PC Logic)
    // Selects between PC+4 or Branch Target
    mux_2x1 pc_branch_mux (
        .a(if_pc_plus_4), 
        .b(mem_pc_branch_target), 
        .sel(branch_decision_taken), 
        .data_out(branch_target_pc)
    );

    // This handles X states during initialization
    assign if_pc_next = branch_decision_taken === 1'bX ? if_pc_plus_4 : branch_target_pc;

    // 3. Data Memory (RAM)
    Data_Memory Datamem (
        .Mem_Addr(mem_alu_result),
        .Write_Data(mem_write_data_store),
        .clk(clk),
        .MemWrite(mem_ctrl_mem_write),
        .MemRead(mem_ctrl_mem_read),
        .Read_Data(mem_read_data_out)
    );

    // 4. MEM/WB Pipeline Register
    MEM_WB mem_wb_reg (
        .clk(clk),
        .ReadData(mem_read_data_out),
        .ALU_result(mem_alu_result),
        .rd(mem_rd),
        .RegWrite(mem_ctrl_reg_write),
        .MemtoReg(mem_ctrl_mem_to_reg),
        // Signals Out (to WB stage)
        .ReadData_store(wb_mem_read_data),
        .ALU_result_store(wb_alu_result),
        .rd_store(wb_rd),
        .RegWrite_store(wb_ctrl_reg_write),
        .MemtoReg_store(wb_ctrl_mem_to_reg)
    );


    mux_2x1 wb_mux (
        .a(wb_alu_result),
        .b(wb_mem_read_data),
        .sel(wb_ctrl_mem_to_reg),
        .data_out(wb_final_write_data)
    );

    // Debug output
    assign debug_MEMWB_writeData = wb_final_write_data;

endmodule