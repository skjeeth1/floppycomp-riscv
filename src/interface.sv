`ifndef INTERFACE_SV
`define INTERFACE_SV


interface if_id_if;
  word pc;
  word pc_plus4;
  word instruction;
  logic valid;
  modport master(output pc, output pc_plus4, output instruction, output valid);
  modport slave (input pc, input pc_plus4, input instruction, input  valid);
endinterface


`endif