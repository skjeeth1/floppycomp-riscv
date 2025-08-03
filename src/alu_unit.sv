`include "params.sv"

module alu_unit (
    input logic valid,
    input word op1, op2, imm, pc_val,
    input alu_rs1_t alu_rs1,
    input alu_rs2_t alu_rs2,
    input alu_op_t alu_op_code,

    output word out
);
    word rs1, rs2;

    always_comb begin : ALU_IMP
        rs1 = (alu_rs1 == ALU_PC_OP) ? pc_val : op1 ;
        rs2 = (alu_rs2 == ALU_IMM_OP) ? imm : op2;

        if (valid) begin
            unique case (alu_op_code)
                NO_ALU_OP: out = imm;
                OP_ALU_ADD: out = rs1 + rs2;
                OP_ALU_SUB: out = rs1 - rs2;
                OP_ALU_SLL: out = rs1 << rs2[4:0];
                OP_ALU_SRL: out = rs1 >> rs2[4:0];
                OP_ALU_SRA: out = rs1 >>> rs2[4:0];
                OP_ALU_OR: out = rs1 | rs2;
                OP_ALU_AND: out = rs1 & rs2;
                OP_ALU_XOR: out = rs1 ^ rs2;
                OP_ALU_SLTU: out = ($unsigned(rs1) < $unsigned(rs2)) ? 'b1 : 'b0;
                OP_ALU_SLT: out = ($signed(rs1) < $signed(rs2)) ? 'b1 : 'b0;

                default: begin 
                    out = 'b0; 
                    $display("ALU: %h %s %h = %h", rs1, alu_op_code, rs2, out);
                end
            endcase
        end else 
            out = 32'b0;
    end 
endmodule
