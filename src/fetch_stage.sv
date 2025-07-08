`include "params.sv"
`include "interface.sv"

module fetch_stage (
    input logic clock,
    input logic reset,
    input logic stall,

    input word inst_data_from_memory,

    input logic pc_branch,
    input word jump_address,

    if_id_if.master if_id_out
);

    word pc_reg;
    word pc_plus4;

    assign pc_plus4 = pc_reg + 4;

    always_ff @( posedge clock ) begin : Update_PC_Logic
        if (reset) begin
            pc_reg <= 'b0;
            if_id_out.valid <= 'b0;
        end else if (!stall) begin
            if_id_out.instruction <= inst_data_from_memory;
            if_id_out.pc <= pc_reg;
            if_id_out.pc_plus4 <= pc_plus4;
            if_id_out.valid <= 1'b1;

            if (pc_branch) 
                pc_reg <= jump_address;
            else 
                pc_reg <= pc_plus4;
        end         
    end
    
endmodule