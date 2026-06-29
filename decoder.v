`include "define.v"
//input instruciton, output funct7 rs2, rs1, funct3, rd, opcode

module decoder(
    input wire [`INST_WIDTH-1:0] inst,

    output wire [6:0]                   opcode,
    output wire [`REG_ADDR_WIDTH-1:0]   rd,
    output wire [2:0]                   funct3,
    output wire [`REG_ADDR_WIDTH-1:0]   rs1,
    output wire [`REG_ADDR_WIDTH-1:0]   rs2,
    output wire [6:0]                   funct7
);

    assign opcode   = inst[6:0];
    assign rd       = inst[11:7];
    assign funct3   = inst[14:12];
    assign rs1      = inst[19:15];
    assign rs2      = inst[24:20];
    assign funct7   = inst[31:25];




endmodule
