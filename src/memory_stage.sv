`include "params.sv"

module memory_stage_addr (
    input logic clock,
    input logic en,

    input word alu_result,
    input word reg_data,

    input memory_op_t mem_op,
    input store_op_t store_op,

    output data_memory_interface_t memory_signals
);

    data_memory_interface_t mem_sig;

    always_comb begin : Assign_Data
        mem_sig.mem_enable = 'b0;
        mem_sig.mem_en = MEM_READ_EN;
        mem_sig.data_in = 'b0;
        mem_sig.address = alu_result;

        unique case (mem_op)
            MEM_LOAD_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_READ_EN;
 
            end
            MEM_STORE_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_WRITE_EN;

                unique case (store_op)
                    STORE_BYTE: mem_sig.data_in = {24'b0,   reg_data[7:0]};
                    STORE_HBYTE: mem_sig.data_in = {16'b0, reg_data[31:16]};
                    STORE_WORD: mem_sig.data_in = reg_data;
                endcase
            end
        endcase
    end

    always_ff @( posedge clock ) begin
        if (en)
            memory_signals <= mem_sig;
    end

    
endmodule


module memory_stage_wait (
    input logic clock,
    input logic en,
    input word mem_data_in,
    input load_op_t load_op,
    input word alu_result,

    output word write_out
);

    word computed_result;

    always_comb begin : LOAD_WORD_FROM_MEM
        computed_result = mem_data_in;
        
        unique case (load_op)
            LOAD_BYTE: begin
                unique case (alu_result[1:0])
                    2'b00: computed_result = {{24{mem_data_in[7]}},   mem_data_in[7:0]};
                    2'b01: computed_result = {{24{mem_data_in[15]}},  mem_data_in[15:8]};
                    2'b10: computed_result = {{24{mem_data_in[23]}},  mem_data_in[23:16]};
                    2'b11: computed_result = {{24{mem_data_in[31]}},  mem_data_in[31:24]};
                endcase
            end

            LOAD_BYTEU: begin
                unique case (alu_result[1:0])
                    2'b00: computed_result = {24'b0, mem_data_in[7:0]};
                    2'b01: computed_result = {24'b0, mem_data_in[15:8]};
                    2'b10: computed_result = {24'b0, mem_data_in[23:16]};
                    2'b11: computed_result = {24'b0, mem_data_in[31:24]};
                endcase
            end

            LOAD_HBYTE: begin
                unique case (alu_result[1])
                    1'b0: computed_result = {{16{mem_data_in[15]}}, mem_data_in[15:0]};
                    1'b1: computed_result = {{16{mem_data_in[31]}}, mem_data_in[31:16]};
                endcase
            end

            LOAD_HBYTEU: begin
                unique case (alu_result[1])
                    1'b0: computed_result = {16'b0, mem_data_in[15:0]};
                    1'b1: computed_result = {16'b0, mem_data_in[31:16]};
                endcase
            end

            LOAD_WORD: computed_result = mem_data_in;  
        endcase
    end

    always_ff @( posedge clock ) begin : WRITE_mem_data_in
        if (en)
            write_out <= computed_result;
    end
    
endmodule