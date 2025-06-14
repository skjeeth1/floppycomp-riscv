`include "params.sv"

module decode_unit (
    input word instruction,

    output control_signals_t ctrl,
    output word reg_val_1, reg_val_2, imm
);

    word imm_i;
    word imm_s;
    word imm_b;
    word imm_u;
    word imm_j;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    reg_index rd;
    reg_index rs1;
    reg_index rs2;

    immediate_generator imm_gen1 (
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b),
        .imm_u(imm_u),
        .imm_j(imm_j)
    );

    always_comb begin : Assign_CTRL_Lines
        opcode = instruction[6:0];
        rd = instruction[11:7];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct7 = instruction[31:25];

        case (opcode)
            OPCODE_R: begin
                ctrl.reg_file_op = WRITE_REG_DATA;
                ctrl.alu_rs1_val = ALU_RS1_OP;
                ctrl.alu_rs2_val = ALU_RS2_OP;
                ctrl.mem_op = MEM_SKIP_OP;
                ctrl.write_back_op = WRITE_BACK_OUT;
                ctrl.branch_op = NO_BRANCH;
                ctrl.branch_enable = BRANCH_DISABLE;
                ctrl.is_jal = JAL_DISABLE;
                ctrl.is_jalr = JALR_DISABLE;

                case ({funct7, funct3})
                    10'b0000000_000: ctrl.alu_op = OP_ALU_ADD;
                    10'b0100000_000: ctrl.alu_op = OP_ALU_SUB;
                    10'b0000000_001: ctrl.alu_op = OP_ALU_SLL;
                    10'b0000000_101: ctrl.alu_op = OP_ALU_SRL;
                    10'b0100000_101: ctrl.alu_op = OP_ALU_SRA;
                    10'b0000000_110: ctrl.alu_op = OP_ALU_OR;
                    10'b0000000_111: ctrl.alu_op = OP_ALU_AND;
                    10'b0000000_100: ctrl.alu_op = OP_ALU_XOR;
                    10'b0000000_010: ctrl.alu_op = OP_ALU_SLT;
                    10'b0000000_011: ctrl.alu_op = OP_ALU_SLTU;
                    default: ; // Keep default
                endcase
            end 
            
            OPCODE_I: begin
                ctrl.reg_file_op = WRITE_REG_DATA;
                ctrl.alu_rs1_val = ALU_RS1_OP;
                ctrl.alu_rs2_val = ALU_IMM_OP;
                ctrl.mem_op = MEM_SKIP_OP;
                ctrl.write_back_op = WRITE_BACK_OUT;
                ctrl.branch_op = NO_BRANCH;
                ctrl.branch_enable = BRANCH_DISABLE;
                ctrl.is_jal = JAL_DISABLE;
                ctrl.is_jalr = JALR_DISABLE;

                case (funct3)
                    3'b000: ctrl.alu_op = OP_ALU_ADD; // ADDI
                    3'b010: ctrl.alu_op = OP_ALU_SLT; // SLTI
                    3'b011: ctrl.alu_op = OP_ALU_SLTU;// SLTIU
                    3'b100: ctrl.alu_op = OP_ALU_XOR; // XORI
                    3'b110: ctrl.alu_op = OP_ALU_OR;  // ORI
                    3'b111: ctrl.alu_op = OP_ALU_AND; // ANDI
                    3'b001: ctrl.alu_op = OP_ALU_SLL; // SLLI
                    3'b101: begin
                        if (instruction[30] == 1'b0)
                            ctrl.alu_op = OP_ALU_SRL; // SRLI
                        else
                            ctrl.alu_op = OP_ALU_SRA; // SRAI
                    end
                    default: ctrl.alu_op = OP_ALU_ADD;
                endcase
            end

            OPCODE_LW: begin
                ctrl.reg_file_op = WRITE_REG_DATA;
                ctrl.alu_op = OP_ALU_ADD;
                ctrl.alu_rs1_val = ALU_RS1_OP;
                ctrl.alu_rs2_val = ALU_IMM_OP;
                ctrl.mem_op = MEM_LOAD_OP;
                ctrl.write_back_op = WRITE_BACK_OUT;
                ctrl.branch_op = NO_BRANCH;
                ctrl.branch_enable = BRANCH_DISABLE;
                ctrl.is_jal = JAL_DISABLE;
                ctrl.is_jalr = JALR_DISABLE;
            end

            OPCODE_SW: begin
                ctrl.reg_file_op = NO_REG_DATA;
                ctrl.alu_op = OP_ALU_ADD;
                ctrl.alu_rs1_val = ALU_RS1_OP;
                ctrl.alu_rs2_val = ALU_IMM_OP;
                ctrl.mem_op = MEM_LOAD_OP;
                ctrl.write_back_op = WRITE_BACK_OUT;
                ctrl.branch_op = NO_BRANCH;
                ctrl.branch_enable = BRANCH_DISABLE;
                ctrl.is_jal = JAL_DISABLE;
                ctrl.is_jalr = JALR_DISABLE;
            end
        endcase
    end
    
endmodule


module immediate_generator (
    input  word instruction,

    output word imm_i,
    output word imm_s,
    output word imm_b,
    output word imm_u,
    output word imm_j
);

    always_comb begin
        imm_i = {
            {20{instruction[31]}},
            instruction[31:20]
        };

        imm_s = {
            {20{instruction[31]}},
            instruction[31:25],
            instruction[11:7]
        };

        imm_b = {
            {19{instruction[31]}},
            instruction[31],
            instruction[7],
            instruction[30:25],
            instruction[11:8],
            1'b0
        };

        imm_u = {
            instruction[31:12],
            12'b0
        };

        imm_j = {
            {11{instruction[31]}},
            instruction[31],
            instruction[19:12],
            instruction[20],
            instruction[30:21],
            1'b0
        };
    end

endmodule
