module task3_tb();

    reg clk;
    reg reset;
    wire [63:0] debug_MEMWB_writeData;

    // Instantiate the Top Module (task_3)
    task_3 a1(clk, reset, debug_MEMWB_writeData);
    
    wire [31:0] Array_Elem_0; 
    wire [31:0] Array_Elem_1; 
    wire [31:0] Array_Elem_2; 
    wire [31:0] Array_Elem_3; 
    wire [31:0] Array_Elem_4; 
    wire [31:0] Array_Elem_5; 
    wire [31:0] Array_Elem_6; 
   

    assign Array_Elem_0 = {a1.Datamem.DataMemory[259], a1.Datamem.DataMemory[258], a1.Datamem.DataMemory[257], a1.Datamem.DataMemory[256]};
    assign Array_Elem_1 = {a1.Datamem.DataMemory[263], a1.Datamem.DataMemory[262], a1.Datamem.DataMemory[261], a1.Datamem.DataMemory[260]};
    assign Array_Elem_2 = {a1.Datamem.DataMemory[267], a1.Datamem.DataMemory[266], a1.Datamem.DataMemory[265], a1.Datamem.DataMemory[264]};
    assign Array_Elem_3 = {a1.Datamem.DataMemory[271], a1.Datamem.DataMemory[270], a1.Datamem.DataMemory[269], a1.Datamem.DataMemory[268]};
    assign Array_Elem_4 = {a1.Datamem.DataMemory[275], a1.Datamem.DataMemory[274], a1.Datamem.DataMemory[273], a1.Datamem.DataMemory[272]};
    assign Array_Elem_5 = {a1.Datamem.DataMemory[279], a1.Datamem.DataMemory[278], a1.Datamem.DataMemory[277], a1.Datamem.DataMemory[276]};
    assign Array_Elem_6 = {a1.Datamem.DataMemory[283], a1.Datamem.DataMemory[282], a1.Datamem.DataMemory[281], a1.Datamem.DataMemory[280]};
    
    initial begin
        clk = 1;
        reset = 1;
        #2 reset = 0;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule