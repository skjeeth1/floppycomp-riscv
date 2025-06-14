`include "params.sv"

module FloppyComp_V1 (
    input logic clock,
    input logic reset,
    input word data_in,
    input word inst_data,

    output word inst_add,
    data_memory_interface_t data_mem_int
);

    control_signals_t ctrl_sig;

    word pc;
    word pc_4;
    word jump_address;
    word instruction;

    reg_index rs1_idx, rs2_idx, rd_idx;
    word rs1, rs2, imm;

    word execute_out;
    word memory_out;
    word reg_input;

    fetch_stage F1 (
        .clock(clock),
        .reset(reset),
        .jump_address(jump_address),
        .memory_inst_data(inst_data),
        .branch_en(ctrl_sig.branch_enable),
        .jal_en(ctrl_sig.is_jal),
        .jalr_en(ctrl_sig.is_jalr),
        .memory_inst_address(inst_add),
        .instruction_out(instruction),
        .pc_4(pc_4),
        .pc(pc)
    );

    decode_stage D1 (
        .instruction(instruction),
        .ctrl(ctrl_sig),
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rd_idx(rd_idx),
        .imm(imm)
    );

    execute_stage E1 (
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .pc(pc),
        .alu_rs1(ctrl_sig.alu_rs1_val),
        .alu_rs2(ctrl_sig.alu_rs2_val),
        .alu_op_code(ctrl_sig.alu_op),
        .branch_op(ctrl_sig.branch_op),
        .jal_op(ctrl_sig.is_jal),
        .jalr_op(ctrl_sig.is_jalr),
        .memory_out(execute_out),
        .branch_scs(ctrl_sig.branch_enable),
        .branch_add_out(jump_address)
    );

    memory_stage M1 (
        .alu_result(execute_out),
        .reg_data(rs2),
        .mem_op(ctrl_sig.mem_op),
        .mem_data_out(data_in),
        .mem_sig(data_mem_int),
        .write_out(memory_out)
    );

    write_back_stage WB1 (
        .pc_4(pc),
        .memory_out(memory_out),
        .write_back_ctrl(ctrl_sig.write_back_op),
        .reg_op(ctrl_sig.reg_file_op),
        .reg_write_data(reg_input)
    );
    
    reg_file R1 (
        .clock(clock),
        .reset(reset),
        .mem_op(ctrl_sig.reg_file_op),
        .rs1(rs1_idx),
        .rs2(rs2_idx),
        .rd(rd_idx),
        .write_data(reg_input),
        .rs1_data(rs1),
        .rs2_data(rs2)
    );


endmodule