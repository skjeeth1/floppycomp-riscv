`include "params.sv"

module alu_rtl (
    input alu_op_t alu_op_code,
    input word rs1,
    input word rs2,
    output word out
);

    always_comb begin : ALU_IMP
        case (alu_op_code)
            OP_ALU_ADD: out = rs1 + rs2;
            OP_ALU_SUB: out = rs1 - rs2;
            OP_ALU_SLL: out = rs1 << rs2;
            OP_ALU_SRL: out = rs1 >> rs2;
            OP_ALU_SRA: out = rs1 >>> rs2;
            OP_ALU_OR: out = rs1 | rs2;
            OP_ALU_AND: out = rs1 & rs2;
            OP_ALU_XOR: out = rs1 ^ rs2;
            OP_ALU_SLTU: out = (rs1 < rs2) ? 'b1 : 'b0;
            OP_ALU_SLT: out = ($signed(rs1) < $signed(rs2)) ? 'b1 : 'b0;

            default: begin 
                out = 'b0; 
                $display("ALU: %h %s %h = %h", rs1, op_name, rs2, out);
            end

        endcase
    end 
endmodule


module execute_unit (
    input word rs1, rs2, imm, pc_val,
    input alu_rs1_t alu_rs1,
    input alu_rs2_t alu_rs2,
    input alu_op_t alu_op,

    output word alu_result
);

    word op1, op2;

    always_comb begin : Assign_Operands
        case (alu_rs1)
            ALU_PC_OP:  op1 = pc_val;
            default:    op1 = rs1;
        endcase

        case (alu_rs2)
            ALU_IMM_OP: op2 = imm;
            default:    op2 = rs2;
        endcase
    end

    alu_rtl ALU1 (
        .alu_op_code(alu_op),
        .rs1(op1),
        .rs2(op2),
        .out(alu_result)
    );

endmodule