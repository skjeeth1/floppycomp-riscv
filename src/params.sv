`ifndef PARAMS_SV
`define PARAMS_SV


parameter WORD_SIZE = 32;
parameter REG_NUM = 32;


parameter OPCODE_R = 7'b0110011;
parameter OPCODE_I = 7'b0010011;
parameter OPCODE_LW = 7'b0000011;
parameter OPCODE_SW = 7'b0100011;
parameter OPCODE_BRANCH = 7'b1100011;
parameter OPCODE_JAL = 7'b1101111;
parameter OPCODE_JALR = 7'b1100111;
parameter OPCODE_LUI = 7'b0110111;
parameter OPCODE_AUIPC = 7'b0010111;


typedef logic [WORD_SIZE - 1:0] word;
typedef logic [4:0] reg_index;

typedef enum logic [2:0] { 
    FETCH_ADDR,
    FETCH_WAIT,
    DECODE,
    EXECUTE,
    MEMORY_ADDR,
    MEMORY_WAIT,
    WRITEBACK
} fsm_state_op_t;

typedef struct packed {
    logic fetch_addr_en;
    logic fetch_inst_en;
    logic alu_en;
    logic branch_en;
    logic memory_en;
    logic write_back_en;
} enable_signals_t;

typedef enum logic [3:0] { 
    NO_ALU_OP,
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
    NO_REG_DATA,
    WRITE_REG_DATA
} reg_file_op_t;


typedef enum logic [2:0] { 
    NO_BRANCH,
    INST_BRCH_EQ,
    INST_BRCH_NEQ,
    INST_BRCH_LST,
    INST_BRCH_GTE,
    INST_BRCH_LSTU,
    INST_BRCH_GTEU
} branch_op_t;


typedef enum logic {
    BRANCH_DISABLE,
    BRANCH_ENABLE
} branch_en_t;


typedef enum logic [1:0] { 
    NO_EXECUTE,
    ALU_EXECUTE,
    BRANCH_EXECUTE,
    JUMP_EXECUTE
} execute_op_t;

typedef enum logic [1:0] { 
    MEM_WRITE_EN,
    MEM_READ_EN
} mem_en_t;


typedef enum logic [1:0] {
    MEM_SKIP_OP,
    MEM_LOAD_OP,
    MEM_STORE_OP
} memory_op_t;


typedef enum logic [2:0] { 
    LOAD_BYTE,
    LOAD_HBYTE,
    LOAD_WORD,
    LOAD_BYTEU,
    LOAD_HBYTEU
 } load_op_t;


typedef enum logic [1:0] { 
    STORE_BYTE,
    STORE_HBYTE,
    STORE_WORD
 } store_op_t;


typedef enum logic [1:0] { 
    NO_WRITE_BACK,
    WRITE_BACK_OUT,
    WRITE_BACK_PC
} write_back_op_t;


typedef enum logic { 
    JAL_DISABLE, 
    JAL_ENABLE 
} jal_op_t;


typedef enum logic { 
    JALR_DISABLE, 
    JALR_ENABLE 
} jalr_op_t;


typedef struct packed {
    logic mem_enable;
    mem_en_t mem_en;
    word address;
    word data_in;
} data_memory_interface_t;


typedef struct packed {
    reg_file_op_t reg_file_op;
    alu_op_t alu_op;
    alu_rs1_t alu_rs1_val;
    alu_rs2_t alu_rs2_val;
    memory_op_t mem_op;
    load_op_t load_op;
    store_op_t store_op;
    write_back_op_t write_back_op;
    branch_op_t branch_op;
    branch_en_t branch_enable;
    jal_op_t is_jal;
    jalr_op_t is_jalr;
} control_signals_t;



`endif