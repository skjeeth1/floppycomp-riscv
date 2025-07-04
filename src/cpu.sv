`include "params.sv"

module FloppyComp_V2 (
    input logic clock,
    input logic reset,
    input word data_in,
    input word inst_data,

    output word inst_add,
    data_memory_interface_t data_mem_int
);

    control_signals_t control_sig;

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

    control_signals_t latched_control_sig;


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
            DECODE: next_state = (control_sig.alu_op == NO_ALU_OP) ? WRITEBACK : EXECUTE;
            EXECUTE: next_state = (control_sig.mem_op == MEM_SKIP_OP) ? WRITEBACK : MEMORY_ADDR;
            MEMORY_ADDR:   next_state = MEMORY_WAIT;
            MEMORY_WAIT:   next_state = (control_sig.mem_op == MEM_LOAD_OP) ? WRITEBACK : FETCH_ADDR;
            WRITEBACK:     next_state = FETCH_ADDR;
            default:       next_state = FETCH_ADDR;
        endcase
    end

    assign pc_update_en = (state == FETCH_ADDR);
    assign fetch_instruction_en = (state == FETCH_WAIT);
    assign decode_en = (state == DECODE);
    assign execute_en = (state == EXECUTE);
    assign memory_stage_addr_en = (state == MEMORY_ADDR);
    assign memory_stage_wait_en = (state == MEMORY_WAIT);
    assign write_back_en = (state == WRITEBACK);

    pc_update PU1 (
        .clock(clock),
        .reset(reset),
        .en(pc_update_en),
        .jump_address(jump_address),
        .branch_en(control_sig.branch_enable),
        .jal_en(control_sig.is_jal),
        .jalr_en(control_sig.is_jalr),
        .memory_inst_address(inst_add),
        .pc_4(pc_4),
        .pc(pc)
    );

    fetch_instruction FI1 (
        .clock(clock),
        .en(fetch_instruction_en),
        .memory_inst_data(inst_data),
        .instruction_out(instruction)
    );

    decode_stage D1 (
        .clock(clock),
        .en(decode_en),
        .instruction(instruction),
        .ctrl_signals(control_sig),
        .rs1_index(rs1_idx),
        .rs2_index(rs2_idx),
        .rd_index(rd_idx),
        .immediate(imm)
    );

    execute_stage E1 (
        .clock(clock),
        .en(execute_en),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .pc(pc),
        .pc_4(pc_4),
        .alu_rs1(control_sig.alu_rs1_val),
        .alu_rs2(control_sig.alu_rs2_val),
        .alu_op_code(control_sig.alu_op),
        .branch_op(control_sig.branch_op),
        .jal_op(control_sig.is_jal),
        .jalr_op(control_sig.is_jalr),
        .execute_result_out(execute_out),
        .branch_success_signal(control_sig.branch_enable),
        .branch_address(jump_address)
    );

    memory_stage_addr MA1 (
        .clock(clock),
        .en(memory_stage_addr_en),
        .alu_result(execute_out),
        .reg_data(rs2),
        .mem_op(control_sig.mem_op),
        .store_op(control_sig.store_op),
        .memory_signals(data_mem_int)
    );

    memory_stage_wait MW1 (
        .clock(clock),
        .en(memory_stage_wait_en),
        .mem_data_in(data_in),
        .load_op(control_sig.load_op),
        .alu_result(execute_out),
        .write_out(memory_out)
    );

    write_back_stage WB1 (
        .clock(clock),
        .en(write_back_en),
        .pc_4(pc),
        .memory_out(memory_out),
        .write_back_ctrl(control_sig.write_back_op),
        .register_op(control_sig.reg_file_op),
        .register_data(reg_input)
    );
    
    reg_file R1 (
        .clock(clock),
        .reset(reset),
        .mem_op(control_sig.reg_file_op),
        .rs1(rs1_idx),
        .rs2(rs2_idx),
        .rd(rd_idx),
        .write_data(reg_input),
        .rs1_data(rs1),
        .rs2_data(rs2)
    );


endmodule