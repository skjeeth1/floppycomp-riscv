`include "params.sv"

module memory_stage (
    input word alu_result,
    input word reg_data,
    input memory_op_t mem_op,
    input load_op_t load_op,
    input store_op_t store_op,
    input word mem_data_out,

    output data_memory_interface_t mem_sig,
    output word write_out
);

    word data_ram_out;

    always_comb begin : Assign_Data
        mem_sig.mem_enable = 'b0;
        mem_sig.mem_en = MEM_READ_EN;
        mem_sig.data_in = 'b0;
        mem_sig.address = alu_result;

        case (mem_op)
            MEM_SKIP_OP: write_out = alu_result;
            MEM_LOAD_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_READ_EN;
                data_ram_out = mem_data_out;

                write_out = data_ram_out;
                
                case (load_op)
                    LOAD_BYTE: begin
                        case (alu_result[1:0])
                            2'b00: write_out = {{24{data_ram_out[7]}},   data_ram_out[7:0]};
                            2'b01: write_out = {{24{data_ram_out[15]}},  data_ram_out[15:8]};
                            2'b10: write_out = {{24{data_ram_out[23]}},  data_ram_out[23:16]};
                            2'b11: write_out = {{24{data_ram_out[31]}},  data_ram_out[31:24]};
                        endcase
                    end

                    LOAD_BYTEU: begin
                        case (alu_result[1:0])
                            2'b00: write_out = {24'b0, data_ram_out[7:0]};
                            2'b01: write_out = {24'b0, data_ram_out[15:8]};
                            2'b10: write_out = {24'b0, data_ram_out[23:16]};
                            2'b11: write_out = {24'b0, data_ram_out[31:24]};
                        endcase
                    end

                    LOAD_HBYTE: begin
                        case (alu_result[1])
                            1'b0: write_out = {{16{data_ram_out[15]}}, data_ram_out[15:0]};
                            1'b1: write_out = {{16{data_ram_out[31]}}, data_ram_out[31:16]};
                        endcase
                    end

                    LOAD_HBYTEU: begin
                        case (alu_result[1])
                            1'b0: write_out = {16'b0, data_ram_out[15:0]};
                            1'b1: write_out = {16'b0, data_ram_out[31:16]};
                        endcase
                    end

                    LOAD_WORD: begin
                        write_out = data_ram_out;
                    end

                endcase
            end
            MEM_STORE_OP: begin
                mem_sig.mem_enable = 'b1;
                mem_sig.mem_en = MEM_WRITE_EN;
                write_out = 'b0;

                mem_sig.data_in = reg_data;

                case (store_op)
                    STORE_BYTE: write_out = {24'b0,   reg_data[7:0]};
                    STORE_HBYTE: mem_sig.data_in = {16'b0, reg_data[31:16]};
                    STORE_WORD: mem_sig.data_in = reg_data;
                endcase
            end
        endcase
    end

    
endmodule