`include "params.sv"

module decode_unit (
    input word instruction,
    output control_signals_t ctrl
);
    logic [6:0] lsb_opcode;
    logic [2:0] mid_opcode;
    logic [6:0] msb_opcode;

    always_comb begin : Assign_CTRL_Lines
        lsb_opcode = instruction[6:0];
        mid_opcode = instruction[14:12];
        msb_opcode = instruction[31:27];

        case (lsb_opcode)
            OPCODE_R: begin
                
            end 
            // default: 
        endcase
    end
    
endmodule