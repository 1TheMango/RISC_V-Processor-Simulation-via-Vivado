`timescale 1ns / 1ps

module RISC_V_Processor_tb;

    // Testbench signals
    reg clk;
    reg reset;
    
    // Instantiate the processor (Unit Under Test)
    RISC_V_Processor uut (
        .clk(clk),
        .reset(reset)
    );

    
    // Clock generation: 10ns period (100MHz)
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 1;
        reset = 1;      // Assert reset
        #10;            // Hold reset for a few cycles
        
        reset = 0;      // Deassert reset (start normal operation)
        
        // Run processor for a certain duration
        #200;
    end

endmodule
