`include "params.sv"

module alu_unit (
    input word op1, op2, imm, pc_val,
    input alu_rs1_t alu_rs1,
    input alu_rs2_t alu_rs2,
    input alu_op_t alu_op_code,

    output word out
);
    word rs1, rs2;

    always_comb begin : ALU_IMP
        rs1 = op1;
        rs2 = op2;
        out = 'b0;
        
        case (alu_rs1)
            ALU_PC_OP:  rs1 = pc_val;
            default:    rs1 = op1;
        endcase

        case (alu_rs2)
            ALU_IMM_OP: rs2 = imm;
            default:    rs2 = op2;
        endcase

        case (alu_op_code)
            NO_ALU_OP: out = imm;
            OP_ALU_ADD: out = rs1 + rs2;
            OP_ALU_SUB: out = rs1 - rs2;
            OP_ALU_SLL: out = rs1 << rs2[4:0];
            OP_ALU_SRL: out = rs1 >> rs2[4:0];
            OP_ALU_SRA: out = rs1 >>> rs2[4:0];
            OP_ALU_OR: out = rs1 | rs2;
            OP_ALU_AND: out = rs1 & rs2;
            OP_ALU_XOR: out = rs1 ^ rs2;
            OP_ALU_SLTU: out = (rs1 < rs2) ? 'b1 : 'b0;
            OP_ALU_SLT: out = ($signed(rs1) < $signed(rs2)) ? 'b1 : 'b0;

            default: begin 
                out = 'b0; 
                $display("ALU: %h %s %h = %h", rs1, alu_op_code, rs2, out);
            end

        endcase
    end 
endmodule
