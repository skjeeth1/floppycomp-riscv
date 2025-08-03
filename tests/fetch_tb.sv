`timescale 1ns / 1ps
`include "../src/params.sv"
`include "../src/interface.sv"

module fetch_tb (
);

    logic clock, reset, stall, pc_branch;
    word inst_data_from_memory;
    word jump_address;
    word instruction_address;

    if_id_if if_id();

    fetch_stage FS1 (
        clock, reset,stall, inst_data_from_memory, pc_branch, jump_address, instruction_address, if_id
    );

    instruction_memory IM1 (
        clock,
        instruction_address,
        inst_data_from_memory
    );

    always #5 clock = ~clock;

    initial begin
        IM1.memory[0] = 32'h00000013;  // NOP (ADDI x0, x0, 0)
        IM1.memory[1] = 32'h00100093;  // ADDI x1, x0, 1
        IM1.memory[2] = 32'h00200113;  // ADDI x2, x0, 2
        IM1.memory[3] = 32'h00308193;  // ADDI x3, x1, 3
        IM1.memory[4] = 32'h02535351;  // ADDI x3, x1, 3
        clock = 0;
        reset = 1; 
        stall= 0;
        pc_branch = 0;

        jump_address = 'b0;

        #15;
        reset = 0;

        #35;
        stall = 1;
        #20;
        stall=0;
    end
    
endmodule