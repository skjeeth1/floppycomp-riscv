`include "params.sv"
`include "interface.sv"

module execute_stage (
    input logic clock,
    input logic reset,
    input logic stall,

    id_ex_if.slave id_ex_in,
    ex_mem_if.master ex_mem_out,

    output branch_en_t branch_scs,
    output word branch_add_out
);

    word alu_out;
    word branch_out;
    
    alu_unit ALU1 (
        .valid(id_ex_in.valid),
        .op1(id_ex_in.rs1_val),
        .op2(id_ex_in.rs2_val),
        .imm(id_ex_in.imm),
        .pc_val(id_ex_in.pc),
        .alu_rs1(id_ex_in.execute_ctrl.alu_rs1),
        .alu_rs2(id_ex_in.execute_ctrl.alu_rs2),
        .alu_op_code(id_ex_in.execute_ctrl.alu_op),
        .out(alu_out)
    );

    branch_unit BRU1 (
        .valid(id_ex_in.valid),
        .rs1(id_ex_in.rs1_val),
        .rs2(id_ex_in.rs2_val),
        .offset(id_ex_in.imm),
        .pc(id_ex_in.pc),
        .branch_op(id_ex_in.execute_ctrl.branch_op),
        .branch_scs(branch_scs),
        .branch_address(branch_out)
    );

    // always_comb begin : Jump_Logic
    //     memory_out = alu_out;
    //     branch_add_out = branch_out;

    //     if (jal_op == JAL_ENABLE) begin
    //         memory_out = pc_4;
    //         branch_add_out = pc + imm;
    //     end else if (jalr_op == JALR_ENABLE) begin
    //         memory_out = pc_4;
    //         branch_add_out = (rs1 + imm) & ~32'd1;
    //     end
    // end

    always_ff @( posedge clock ) begin
        if (reset)
            ex_mem_out.valid <= 'b0;
        else if (!stall) begin
            if (id_ex_in.valid) begin
                ex_mem_out.memory_ctrl <= id_ex_in.memory_ctrl;
                ex_mem_out.write_back_ctrl <= id_ex_in.write_back_ctrl;
                ex_mem_out.execute_out <= (id_ex_in.execute_ctrl.is_jal == JAL_ENABLE || id_ex_in.execute_ctrl.is_jalr == JALR_ENABLE) ? id_ex_in.pc_plus4 : alu_out;
                ex_mem_out.reg_data <= id_ex_in.rs2_val;
                ex_mem_out.rd_idx <= id_ex_in.rd_idx;
                ex_mem_out.valid <= 1'b1;
            end else begin
                ex_mem_out.memory_ctrl <= '0;
                ex_mem_out.write_back_ctrl <= '0;
                ex_mem_out.execute_out <= '0;
                ex_mem_out.reg_data <= '0;
                ex_mem_out.rd_idx <= '0;
                ex_mem_out.valid <= 1'b0;
            end
        end
    end
    
endmodule