`timescale 1ns / 1ps

module Hazard_Detection_Unit(
    input reset,
    input id_ex_memread,
    input [4:0] id_ex_rd, if_id_rs1, if_id_rs2,
    input [63:0] PC_final,
    input [63:0] EXMEM_PC_with_immediate_store,
    input [63:0] PC_plus_4_to_mux,
    output reg stall_pc,
    output reg stall_if_id,
    output reg flush_id_ex
    );

    always @(*) begin
        if (reset) begin
            stall_pc = 0;
            stall_if_id = 0;
            flush_id_ex = 0;
        end else begin
            //Load-Use Hazard
            if (id_ex_memread && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin
                stall_pc = 1;
                stall_if_id = 1;
                flush_id_ex = 1;
            end else begin
                stall_pc = 0;
                stall_if_id = 0;
                flush_id_ex = 0;
            end
        end
    end
endmodule
