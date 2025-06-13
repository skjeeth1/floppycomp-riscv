`include "../src/params.sv"

// module alu_tb(
    
// );
//     alu_op oper;
//     logic [WORD_SIZE - 1:0] a, b, s;

//     alu_rtl A1 (oper, a, b, s);
    
//     initial begin
//         oper = OP_ALU_ADD;
//         a = 'h32;
//         b = 'h32;
//         #20;
//         oper = OP_ALU_SUB;

//     end

// endmodule

module fetch_tb;
    logic clock, reset, jmp_ctrl_signal;
    logic [WORD_SIZE - 1:0] jump_address, memory_inst_data, memory_inst_address, decode_instruction;

    fetch_unit A1 (
        .clock(clock),
        .reset(reset),
        .jmp_ctrl_signal(jmp_ctrl_signal),
        .jump_address(jump_address),
        .memory_inst_data(memory_inst_data),
        .memory_inst_address(memory_inst_address),
        .decode_instruction(decode_instruction)
    );
    
    initial begin
        clock = 0;
        forever #10 clock <= ~clock;
    end
    
    initial begin
        reset = 1;
        #20;
        reset = 0;
        jmp_ctrl_signal = 0;
        memory_inst_data = 32'h36573475;
    end


endmodule