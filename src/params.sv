`ifndef PARAMS_SV
`define PARAMS_SV


parameter WORD_SIZE = 32;


parameter OPCODE_R = 7'b0110011;
parameter OPCODE_I = 7'b0010011;
parameter OPCODE_LW = 7'b0000011;
parameter OPCODE_SW = 7'b0100011;
parameter OPCODE_BRANCH = 7'b1100011;


typedef logic [WORD_SIZE - 1:0] word;


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
    OP_ALU_SLTU
} alu_op_t;


typedef enum logic {
    ALU_RS1_OP,
    ALU_PC_OP
} alu_rs1_t;


typedef enum logic {
    ALU_RS2_OP,
    ALU_IMM_OP
} alu_rs2_t;


typedef enum logic {
    READ_REG_DATA,
    WRITE_REG_DATA
} reg_file_op_t;


typedef enum logic [1:0] { 
    MEM_WRITE_EN,
    MEM_READ_EN,
    MEM_NO_OP
} mem_op_t;


typedef struct packed {
    reg_file_op_t reg_file_op;
} control_signals_t;


`endif