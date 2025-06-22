`include "params.sv"

module fetch_stage (
    input logic clock,
    input logic reset,
    input word jump_address,
    input word memory_inst_data,

    input branch_en_t branch_en,
    input jal_op_t jal_en,
    input jalr_op_t jalr_en,

    output word memory_inst_address,
    output word instruction_out,
    output word pc_4,
    output word pc
);

    word pc_reg;

    always_comb begin
        pc_4 = pc_reg + 4;
        pc = pc_reg;
    end

    always_ff @(posedge clock or posedge reset) begin : address_out
        if (reset) begin
            pc_reg <= 'b0;
        end else begin
            pc_reg <= (branch_en == BRANCH_ENABLE || jal_en == JAL_ENABLE || jalr_en == JALR_ENABLE) ? jump_address : pc_4;
        end
    end

    always_comb begin : output_instruction
        memory_inst_address = pc_reg;
        instruction_out = memory_inst_data;
    end
    
endmodule