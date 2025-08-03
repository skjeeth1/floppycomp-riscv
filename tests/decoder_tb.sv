`include "../src/params.sv"

module decode_tb (
    
);
    logic [WORD_SIZE - 1:0] instruction;
    control_signals_t ctrl;
    logic [6:0] opcode;

    decode D1 (instruction, ctrl);
endmodule