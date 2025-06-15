`timescale 1ns / 1ps
`include "../src/params.sv"

module FloppyComp_V1_tb;
    logic clock = 0;
    logic reset = 1;

    always #5 clock = ~clock;

    word inst_data;
    word data_in;
    word inst_add;
    data_memory_interface_t data_mem_int;

    FloppyComp_V1 cpu (
        .clock(clock),
        .reset(reset),
        .data_in(data_in),
        .inst_data(inst_data),
        .inst_add(inst_add),
        .data_mem_int(data_mem_int)
    );

    word instr_mem [0:255];

    initial begin
        instr_mem[0] = 32'h00500093;  // addi x1, x0, 5
        instr_mem[1] = 32'h00500113;  // addi x2, x0, 5
        instr_mem[2] = 32'h00208263;  // beq x1, x2, +8 (i.e., skip one instruction)
        instr_mem[3] = 32'h06300193;  // addi x3, x0, 99
        instr_mem[4] = 32'h02a00193;  // addi x3, x0, 42
        instr_mem[5] = 32'h0000006f;  // jal x0, 0

        reset = 1;
        #10 reset = 0;

        repeat (50) begin
            #1;
            inst_data = instr_mem[cpu.inst_add[9:2]];
            data_in   = 32'd0; 
            #9;
        end

        // $display("Simulation done.");
        $finish;
    end

endmodule

