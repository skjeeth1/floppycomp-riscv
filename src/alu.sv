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
                $error("Invalid ALU op code %x",alu_op_code); 
            end

        endcase
    end 
endmodule


module alu_decoder (
    input word rs1, rs2, imm, pc_val,
    input alu_rs1_t alu_rs1,
    input alu_rs2_t alu_rs2,

    output word op1, op2
);
    always_comb begin : Assign_OP1
        if (alu_rs1 == ALU_PC_OP) op1 = pc_val;
        else op1 = rs1;

        if (alu_rs2 == ALU_IMM_OP) op2 = imm;
        else op2 = rs1;
    end
endmodule