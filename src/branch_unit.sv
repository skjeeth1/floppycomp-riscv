`include "params.sv"

module branch_unit (
    input word rs1, rs2, pc, offset,
    input branch_op_t branch_op,

    output logic branch_scs,
    output word branch_address
);

    word target_brnch;

    always_comb begin : Branch_logic
        target_brnch   = pc + offset;
        branch_address = '0;
        branch_scs     = 1'b0;

        case (branch_op)
            INST_BRCH_EQ: begin
                if (rs1 == rs2) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            INST_BRCH_NEQ: begin
                if (rs1 != rs2) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            INST_BRCH_LST: begin
                if ($signed(rs1) < $signed(rs2)) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            INST_BRCH_GTE: begin
                if ($signed(rs1) >= $signed(rs2)) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            INST_BRCH_LSTU: begin
                if (rs1 < rs2) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            INST_BRCH_GTEU: begin
                if (rs1 >= rs2) begin
                    branch_address = target_brnch;
                    branch_scs     = 1'b1;
                end
            end
            default: begin
                branch_address = '0;
                branch_scs     = 1'b0;
            end
        endcase
    end

endmodule
