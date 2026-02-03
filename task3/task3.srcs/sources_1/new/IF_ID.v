`timescale 1ns / 1ps

module IF_ID_2 (
    input clk,          
    input reset,      
    input [63:0] PC_addr,     
    input [31:0] Inst,    
    input IF_ID_Write, 
    input flush,
    output reg [63:0] PC_addr_store,  
    output reg [31:0] Inst_store 
);

always @(posedge clk) begin
    if (flush) begin
        PC_addr_store <= 64'd0;
        Inst_store <= 32'd0;
    end
    else if (IF_ID_Write) begin
        PC_addr_store <= PC_addr;
        Inst_store <= Inst;
    end
end

endmodule
