typedef enum logic [4:0] { 
    OP_ALU_ADD,
    OP_ALU_SUB,
    OP_ALU_SLL,
    OP_ALU_SRL,
    OP_ALU_SRA,
    OP_ALU_OR,
    OP_ALU_AND,
    OP_ALU_XOR,
    OP_ALU_SLT,
    OP_ALU_STLU
} alu_op;

module alu_rtl #(
    parameter WORD_SIZE = 32

) (
    input logic a, b
);
    
endmodule