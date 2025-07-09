`include "params.sv"
`include "interface.sv"

// TODO: Correct Stall Logic. When stalls happen, the module has tendency to skip one instruction. 
module fetch_stage (
    input logic clock,
    input logic reset,
    input logic stall,

    input word inst_data_from_memory,

    input logic pc_branch,
    input word jump_address,

    output word instruction_address,
    if_id_if.master if_id_out
);

    word pc_prev;
    word pc_reg;
    word pc_plus4;

    assign pc_plus4 = pc_reg + 4;
    assign instruction_address = pc_reg;

    logic res_pipeline = 1'b1;

    always_ff @( posedge clock ) begin : Update_PC_Logic  
        if (reset) begin
            pc_reg <= 'b0;
            pc_prev <= 'b0;

            if_id_out.instruction <= 'b0;
            if_id_out.pc <= 'b0;
            if_id_out.pc_plus4 <= 'b0;
            if_id_out.valid <= 1'b0;
            
            res_pipeline <= 1'b0;
        end else if (stall) begin
            // res_pipeline <= 1'b0;
        end else begin
            if (res_pipeline) begin
                if_id_out.instruction <= inst_data_from_memory;
                if_id_out.pc <= pc_prev;
                if_id_out.pc_plus4 <= pc_reg;
                if_id_out.valid <= 1'b1;
            end

            pc_prev <= pc_reg;
            pc_reg <= (pc_branch) ? jump_address : pc_plus4;
            res_pipeline <= 1'b1;
        end 
    end
    
endmodule