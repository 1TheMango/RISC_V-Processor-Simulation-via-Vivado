`timescale 1ns / 1ps

module pipelined_imm_gen(
    input [31:0] ins,
    output reg [63:0] imm_data
);
always @ (ins) begin
    case (ins[6:5])
        2'b00: imm_data = ins[31:20];                                           // I-type
        2'b01: imm_data = {ins[31:25], ins[11:7]};                              // S-type
        2'b11: imm_data = {ins[31], ins[7], ins[30:25], ins[11:8]};             // B-type
//        2'b11: imm_data = {ins[31], ins[19:12], ins[20], ins[30:21]};           // U-type
    endcase
end

// Sign extension to 64 bits
always @ (ins) begin
    case (ins[31])
        1'b1: imm_data[63:12] = {52{1'b1}};
        1'b0: imm_data[63:12] = {52{1'b0}};
    endcase
end
endmodule
