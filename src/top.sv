`include "params.sv"

module top (
    input logic clock,
    input logic reset
);

    data_memory_interface_t data_mem_int;
    word data_mem_out;
    word inst_mem_out;
    word inst_mem_add;

    FloppyComp_V1 FCV1 (
        .clock(clock),
        .reset(reset),
        .data_in(data_mem_out),
        .inst_data(inst_mem_out),
        .inst_add(inst_mem_add)
    );

    data_memory DM1 (
        .clock(clock),
        .mem_sig(data_mem_int),
        .data_out(data_mem_out)
    );

    instruction_memory IM1 (
        .data_address(inst_mem_add),
        .instruction(inst_mem_out)
    );
    
endmodule