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
endmodule 


module instruction_memory (
    input word data_address,
    output word instruction
);

    word memory [0:255];
    
    always_comb begin : Instruction_Mem
        instruction = memory[data_address[9:2]];
    end

    initial begin
        $readmemh("program.hex", memory);
    end
    
endmodule
