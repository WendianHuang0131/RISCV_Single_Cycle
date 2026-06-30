`include "define.v"

module cpu(
    input wire clk,
    input wire rst
);

wire [`ADDR_WIDTH-1:0] pc_current;
wire [`ADDR_WIDTH-1:0] pc_next;
wire [`INST_WIDTH-1:0] inst;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;

wire [`REG_ADDR_WIDTH-1:0] rs1;
wire [`REG_ADDR_WIDTH-1:0] rs2;
wire [`REG_ADDR_WIDTH-1:0] rd;

wire [`DATA_WIDTH-1:0] rs1_data;
wire [`DATA_WIDTH-1:0] rs2_data;
wire [`DATA_WIDTH-1:0] alu_result;

wire [3:0] alu_ctrl;
wire reg_write;

wire [`DATA_WIDTH-1:0] imm;
wire [`DATA_WIDTH-1:0] alu_operand_b;
wire alu_src;

assign alu_src = (opcode == `OPCODE_I);
assign alu_operand_b = alu_src ? imm : rs2_data;

assign pc_next = pc_current + 32'd4;

assign reg_write = (opcode == `OPCODE_R);

pc u_pc (
    .clk     (clk),
    .rst     (rst),
    .pc_next (pc_next),
    .pc      (pc_current)
);

inst_mem u_inst_mem (
    .addr (pc_current),
    .inst (inst)
);

decoder u_decoder (
    .inst   (inst),
    .opcode (opcode),
    .rd     (rd),
    .funct3 (funct3),
    .rs1    (rs1),
    .rs2    (rs2),
    .funct7 (funct7)
);

regfile u_regfile (
    .clk       (clk),
    .rst       (rst),
    .rs1       (rs1),
    .rs2       (rs2),
    .rd        (rd),
    .reg_write (reg_write),
    .wb_data   (alu_result),
    .rs1_data  (rs1_data),
    .rs2_data  (rs2_data)
);

alu_control u_alu_control (
    .opcode   (opcode),
    .funct7   (funct7),
    .funct3   (funct3),
    .alu_ctrl (alu_ctrl)
);

alu u_alu (
    .operand_a  (rs1_data),
    .operand_b  (alu_operand_b ),
    .alu_ctrl   (alu_ctrl),
    .alu_result (alu_result)
);

endmodule
