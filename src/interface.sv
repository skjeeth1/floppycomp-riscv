`ifndef INTERFACE_SV
`define INTERFACE_SV


interface if_id_if;
  word pc;
  word pc_plus4;
  word instruction;
  logic valid;
  modport master (output pc, pc_plus4, instruction, valid);
  modport slave (input pc, pc_plus4, instruction, valid);
endinterface


interface id_ex_if;
  control_signals_t ctrl;
  reg_index rs1_idx, rs2_idx, rd_idx;
  word rs1_val, rs2_val, imm, pc, pc_plus4;
  logic valid;
  modport master (output ctrl, rs1_idx, rs2_idx, rd_idx, rs1_val, rs2_val, imm, pc, pc_plus4, valid);
  modport slave (input ctrl, rs1_idx, rs2_idx, rd_idx, rs1_val, rs2_val, imm, pc, pc_plus4, valid);
endinterface


`endif