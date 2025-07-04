`include "params.sv"

module pc_update (
    input logic clock,
    input logic reset,
    input logic en,
    input word jump_address,

    input branch_en_t branch_en,
    input jal_op_t jal_en,
    input jalr_op_t jalr_en,

    output word memory_inst_address,
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
            if (en) begin
                pc_reg <= (branch_en == BRANCH_ENABLE || jal_en == JAL_ENABLE || jalr_en == JALR_ENABLE) ? jump_address : pc_4;
            end 
        end
    end

    always_comb begin : OUTPUT_INSTRUCTION_ADDRESS
        memory_inst_address = pc_reg;
    end
    
endmodule


module fetch_instruction (
    input logic clock,
    input logic en,
    input word memory_inst_data,

    output word instruction_out
);

    always_ff @(posedge clock) begin : OUTPUT_INSTRUCTION
        if (en)
            instruction_out <= memory_inst_data;
    end
    
endmodule