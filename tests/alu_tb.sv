`include "../src/params.sv"

module alu_tb(
    
);
    alu_op oper;
    logic [WORD_SIZE - 1:0] a, b, s;

    alu_rtl A1 (oper, a, b, s);
    
    initial begin
        oper = OP_ALU_ADD;
        a = 'h32;
        b = 'h32;
        #20;
        oper = OP_ALU_SUB;

    end

endmodule