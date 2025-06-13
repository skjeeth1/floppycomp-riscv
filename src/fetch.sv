`include "params.sv"

module fetch_unit (
    input logic clock,
    input logic reset,
    input logic jmp_ctrl_signal,
    input logic [WORD_SIZE - 1:0] jump_address,
    input logic [WORD_SIZE - 1:0] memory_inst_data,

    output mem_op_t mem_op, 
    output logic [WORD_SIZE - 1:0] memory_inst_address,
    output logic [WORD_SIZE - 1:0] instruction_out
);

    logic [WORD_SIZE - 1:0] pc_reg;

    always_ff @(posedge clock or posedge reset) begin : address_out
        if (reset) begin
            pc_reg <= 'b0;
        end else begin
            pc_reg <= (jmp_ctrl_signal) ? jump_address : (pc_reg + 4);
        end
    end

    always_comb begin : output_instruction
        memory_inst_address = pc_reg;
        mem_op = MEM_READ_EN;
        instruction_out = memory_inst_data;
    end
    
endmodule