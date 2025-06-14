`include "params.sv"

module data_memory (
    input logic clock,
    input data_memory_interface_t mem_sig,

    output word data_out
);
    
    word memory [0:255];

    always_ff @( posedge clock ) begin : Write_Data
        if (mem_sig.mem_enable && mem_sig.mem_en == MEM_WRITE_EN) begin
            memory[mem_sig.address[9:2]] <= mem_sig.data_in;
        end
    end

    always_comb begin
        if (mem_sig.mem_enable && mem_sig.mem_en == MEM_READ_EN) 
            data_out = memory[mem_sig.address[9:2]];
        else data_out = 'bz;
    end
endmodule