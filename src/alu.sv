`include "params.sv"

module alu_rtl (
    input alu_op alu_op_code,
    input logic [WORD_SIZE - 1:0] rs1,
    input logic [WORD_SIZE - 1:0] rs2,
    output logic [WORD_SIZE - 1:0] out
);

    always_comb begin : alu_out
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