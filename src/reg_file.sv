`include "params.sv"

module reg_file (
    input logic clock,
    input reg_file_op_t mem_op,
    input reg_index rs1, rs2, rd,
    input word write_data,
    
    output word rs1_data, rs2_data
);

    logic [WORD_SIZE-1 : 0] registers [0 : 31];

    always_ff @(posedge clock) begin : Write_Data_to_Reg
        if (mem_op == WRITE_REG_DATA && rd != 5'd0) begin
            registers[rd] <= write_data;
        end
    end

    always_comb begin : Read_Data_RS1
        if (mem_op == READ_REG_DATA) begin
            if (rs1 == 5'd0)
                rs1_data = '0;
            else
                rs1_data = registers[rs1];
        end
    end

    always_comb begin : Read_Data_RS2
        if (mem_op == READ_REG_DATA) begin
            if (rs2 == 5'd0)
                rs2_data = '0;
            else
                rs2_data = registers[rs2];
        end
    end
    
endmodule