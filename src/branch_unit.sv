`include "params.sv"

module branch_unit (
    input logic valid,
    input word rs1, rs2, pc, offset,
    input branch_op_t branch_op,

    output branch_en_t branch_scs,
    output word branch_address
);

    word target_brnch;

    always_comb begin : Branch_logic
        if (valid) begin
            target_brnch = pc + offset;

            case (branch_op)
                INST_BRCH_EQ: branch_scs = (rs1 == rs2) ? BRANCH_ENABLE : BRANCH_DISABLE;
                INST_BRCH_NEQ: branch_scs = (rs1 != rs2) ? BRANCH_ENABLE : BRANCH_DISABLE;
                INST_BRCH_LST: branch_scs = ($signed(rs1) < $signed(rs2)) ? BRANCH_ENABLE : BRANCH_DISABLE;
                INST_BRCH_GTE: branch_scs = ($signed(rs1) >= $signed(rs2)) ? BRANCH_ENABLE : BRANCH_DISABLE;
                INST_BRCH_LSTU: branch_scs = (rs1 < rs2) ? BRANCH_ENABLE : BRANCH_DISABLE;
                INST_BRCH_GTEU: branch_scs = (rs1 >= rs2) ? BRANCH_ENABLE : BRANCH_DISABLE;
                default: branch_scs = BRANCH_DISABLE;
            endcase

            branch_address = (branch_scs == BRANCH_ENABLE) ? target_brnch : 'b0;
        end else begin
            target_brnch = 'b0;
            branch_scs = BRANCH_DISABLE;
            branch_address = 'b0;
        end
    end

endmodule
