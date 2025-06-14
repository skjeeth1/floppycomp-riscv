`include "params.sv"

module fetch_unit (
    input logic clock,
    input logic reset,
    input logic jmp_ctrl_signal,
    input word jump_address,
    input word memory_inst_data,

    output mem_en_t mem_op, 
    output word memory_inst_address,
    output word instruction_out,
    output word pc_4
);

    word pc_reg;

    always_comb begin
        pc_4 = pc_reg + 4;
    end

    always_ff @(posedge clock or posedge reset) begin : address_out
        if (reset) begin
            pc_reg <= 'b0;
        end else begin
            pc_reg <= (jmp_ctrl_signal) ? jump_address : pc_4;
        end
    end

    always_comb begin : output_instruction
        memory_inst_address = pc_reg;
        mem_op = MEM_READ_EN;
        instruction_out = memory_inst_data;
    end
    
endmodule