`include "params.sv"

module write_unit (
    input word alu_result,
    input word reg_data,
    input mem_op_t mem_op,
    input word mem_data_out,

    output data_memory_interface_t mem_sig,
    output word write_out
);

    always_comb begin : Assign_Data
        mem_sig.mem_enable = 'b0;
        mem_sig.mem_en = MEM_READ_EN;
        mem_sig.data_in = 'b0;
        mem_sig.address = alu_result;

        case (mem_op)
            MEM_SKIP_OP: write_out =  alu_result;
            MEM_LOAD_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_READ_EN;
                write_out = mem_data_out;
            end
            MEM_STORE_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_WRITE_EN;
                mem_sig.data_in = reg_data;
                write_out = 'b0;
            end
        endcase
    end

    
endmodule