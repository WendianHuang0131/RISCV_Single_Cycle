`ifndef DEFINE_V
`define DEFINE_V


`define DATA_WIDTH 32
`define ADDR_WIDTH 32
`define REG_ADDR_WIDTH 5
`define INST_WIDTH 32


`define OPCODE_R        7'b0110011
`define OPCODE_I        7'b0010011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111


`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001


`endif
