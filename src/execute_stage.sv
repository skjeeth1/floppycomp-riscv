`include "params.sv"

module execute_stage (
    input word rs1, rs2, imm, pc, pc_4,

    input alu_rs1_t alu_rs1,
    input alu_rs2_t alu_rs2,
    input alu_op_t alu_op_code,

    input branch_op_t branch_op,

    input jal_op_t jal_op,
    input jalr_op_t jalr_op,

    output word result_out,

    output branch_en_t branch_scs,
    output word branch_add_out

);

    word alu_out;
    word branch_out;
    
    alu_unit ALU1 (
        .op1(rs1),
        .op2(rs2),
        .imm(imm),
        .pc_val(pc),
        .alu_rs1(alu_rs1),
        .alu_rs2(alu_rs2),
        .alu_op_code(alu_op_code),
        .out(alu_out)
    );

    branch_unit BRU1 (
        .rs1(rs1),
        .rs2(rs2),
        .offset(imm),
        .pc(pc),
        .branch_op(branch_op),
        .branch_scs(branch_scs),
        .branch_address(branch_out)
    );

    always_comb begin : Jump_Logic
        result_out = alu_out;
        branch_add_out = branch_out;

        if (jal_op == JAL_ENABLE) begin
            result_out = pc_4;
            branch_add_out = pc + imm;
        end else if (jalr_op == JALR_ENABLE) begin
            result_out = pc_4;
            branch_add_out = (rs1 + imm) & ~32'd1;
        end
    end
    
endmodule