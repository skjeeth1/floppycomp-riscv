`include "params.sv"

module FloppyComp_V2 (
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

    reg_index rs1_idx, rs2_idx, rd_idx;
    word rs1, rs2, imm;

    word instruction;
    word execute_out;
    word memory_out;
    word reg_input;

    word bus;

    fsm_state_op_t state;
    fsm_state_op_t next_state;

    control_signals_t latched_ctrl_sig;


    always_ff @( posedge clock or posedge reset) begin : CPU_FSM
        if (reset) begin
            state <= FETCH_ADDR;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin : CONTROL_BLOCK
        unique case (state)
            FETCH_ADDR:   next_state = FETCH_WAIT;
            FETCH_WAIT:   next_state = DECODE;
            DECODE: next_state = (ctrl_sig.alu_op == NO_ALU_OP) ? WRITEBACK : EXECUTE;
            EXECUTE: next_state = (ctrl_sig.mem_op == MEM_SKIP_OP) ? WRITEBACK : MEMORY_ADDR;
            MEMORY_ADDR:   next_state = MEMORY_WAIT;
            MEMORY_WAIT:   next_state = (ctrl_sig.mem_op == MEM_LOAD_OP) ? WRITEBACK : FETCH_ADDR;
            WRITEBACK:     next_state = FETCH_ADDR;
            default:       next_state = FETCH_ADDR;
        endcase
    end

    assign pc_update_en = (state == FETCH_ADDR);
    assign fetch_instruction_en = (state == FETCH_WAIT);
    assign decode_en = (state == DECODE);
    assign execute_en = (state == EXECUTE);
    // assign memory_add_

    pc_update PU1 (
        .clock(clock),
        .reset(reset),
        .en(fetch_addr_en),
        .jump_address(jump_address),
        .branch_en(ctrl_sig.branch_enable),
        .jal_en(ctrl_sig.is_jal),
        .jalr_en(ctrl_sig.is_jalr),
        .memory_inst_address(inst_add),
        .pc_4(pc_4),
        .pc(pc)
    );

    fetch_instruction_unit FI1 (
        .clock(clock),
        .en(fetch_inst_en),
        .memory_inst_data(inst_data),
        .instruction_out(instruction)
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
        .pc_4(pc_4),
        .alu_rs1(ctrl_sig.alu_rs1_val),
        .alu_rs2(ctrl_sig.alu_rs2_val),
        .alu_op_code(ctrl_sig.alu_op),
        .branch_op(ctrl_sig.branch_op),
        .jal_op(ctrl_sig.is_jal),
        .jalr_op(ctrl_sig.is_jalr),
        .result_out(execute_out),
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