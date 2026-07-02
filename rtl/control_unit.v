`include "define.v"

// input opcode, drive control signal
module control_unit(
    input  wire [6:0]   opcode,

    output wire         reg_write;
    output wire         alu_src;
    output wire         mem_write;
    output wire [1:0]   wb_sel;
    output wire         is_branch;
    output wire         is_jal;
    output wire         is_jalr;
    output wire         branch_taken;
);



endmodule