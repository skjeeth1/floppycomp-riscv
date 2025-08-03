`ifndef INTERFACE_SV
`define INTERFACE_SV


interface if_id_if;
  word pc;
  word pc_plus4;
  word instruction;
  
  logic valid;

  modport master (
    output pc, pc_plus4, instruction, valid
  );
  
  modport slave (
    input pc, pc_plus4, instruction, valid
  );
endinterface


interface id_ex_if;
  // Control Signals
  execute_ctrl_t execute_ctrl;
  memory_ctrl_t memory_ctrl;
  write_back_ctrl_t write_back_ctrl;

  // Register Signals
  reg_index rs1_idx, rs2_idx, rd_idx;
  word rs1_val, rs2_val, imm, pc, pc_plus4;

  logic valid;

  modport master (
    output execute_ctrl,
    output memory_ctrl, 
    output write_back_ctrl, 
    output rs1_idx, rs2_idx, rd_idx, 
    output rs1_val, rs2_val, 
    output imm, pc, pc_plus4, 
    output valid
  );

  modport slave (
    input execute_ctrl,
    input memory_ctrl, 
    input write_back_ctrl, 
    input rs1_idx, rs2_idx, rd_idx, 
    input rs1_val, rs2_val, 
    input imm, pc, pc_plus4, 
    input valid
  );
endinterface


interface ex_mem_if;
  // Control Signals
  memory_ctrl_t memory_ctrl;
  write_back_ctrl_t write_back_ctrl;

  word execute_out;
  word reg_data;
  reg_index rd_idx;
  
  logic valid;

  modport master (
    output memory_ctrl,
    output write_back_ctrl,
    output execute_out,
    output reg_data,
    output rd_idx,
    output valid
  );

  modport slave (
    input memory_ctrl,
    input write_back_ctrl,
    input execute_out,
    input reg_data,
    input rd_idx,
    input valid
  );

endinterface : ex_mem_if



`endif