`include "params.sv"

module write_back_stage (
    input logic clock,
    input logic en,

    input word pc_4,
    input word memory_out,
    input write_back_op_t write_back_ctrl,

    output reg_file_op_t register_op,
    output word register_data
);
    
    word reg_write_data;
    reg_file_op_t reg_op;

    always_comb begin : Write_Back_to_Reg
        reg_op = NO_REG_DATA;
        reg_write_data = 'b0;

        unique case (write_back_ctrl)
            NO_WRITE_BACK: reg_op = NO_REG_DATA;
            WRITE_BACK_PC: begin
                reg_op = WRITE_REG_DATA;
                reg_write_data = pc_4;
            end
            WRITE_BACK_OUT: begin
                reg_op = WRITE_REG_DATA;
                reg_write_data = memory_out;
            end
            default: begin
                reg_op = NO_REG_DATA;
                reg_write_data = 'b0;
            end 
        endcase
    end

    always_ff @( posedge clock ) begin
        if (en) begin
            register_data <= reg_write_data;
            register_op <= reg_op;
        end
    end
endmodule