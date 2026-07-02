`include "define.v"

module cpu(
    input wire clk,
    input wire rst
);

//TODO: move some control signals to control_unit.v
// reg_write
// mem_write
// alu_src
// wb_sel
// is_branch
// is_jal
// js_jalr
// branch_taken



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
wire [`DATA_WIDTH-1:0] imm;

wire [`DATA_WIDTH-1:0] alu_operand_b;
wire [`DATA_WIDTH-1:0] alu_result;

wire [3:0] alu_ctrl;

//TODO, move this control signal into control_unit
wire reg_write;
//TODO, move this control signal into control_unit
wire alu_src;
//TODO, move this control signal into control_unit
wire mem_write;
//TODO, move this control signal into control_unit
wire [1:0] wb_sel;
//TODO, move this control signal into control_unit
wire is_branch;
//TODO, move this control signal into control_unit
wire is_jal;
//TODO, move this control signal into control_unit
wire is_jalr;
//TODO, move this control signal into control_unit
wire branch_taken;

wire [`DATA_WIDTH-1:0] mem_read_data;
wire [`DATA_WIDTH-1:0] wb_data;
wire [`ADDR_WIDTH-1:0] pc_plus_4;
wire [`ADDR_WIDTH-1:0] branch_target;
wire [`ADDR_WIDTH-1:0] jal_target;
wire [`ADDR_WIDTH-1:0] jalr_target;

// ============================================================
// Instruction type detect
// ============================================================

assign is_branch = (opcode == `OPCODE_BRANCH);
assign is_jal    = (opcode == `OPCODE_JAL);
assign is_jalr   = (opcode == `OPCODE_JALR);

// ============================================================
// Control signals
// ============================================================

assign reg_write = (opcode == `OPCODE_R)    ||
                   (opcode == `OPCODE_I)    ||
                   (opcode == `OPCODE_LOAD) ||
                   (opcode == `OPCODE_JAL)  ||
                   (opcode == `OPCODE_JALR);

assign alu_src = (opcode == `OPCODE_I)     ||
                 (opcode == `OPCODE_LOAD)  ||
                 (opcode == `OPCODE_STORE) ||
                 (opcode == `OPCODE_JALR);


assign mem_write = (opcode == `OPCODE_STORE);


assign wb_sel = (opcode == `OPCODE_LOAD) ? `WB_MEM :
                (opcode == `OPCODE_JAL || opcode == `OPCODE_JALR) ? `WB_PC4 :
                `WB_ALU;

assign alu_operand_b = alu_src ? imm : rs2_data;

// ============================================================
// PC next logic
// ============================================================

assign pc_plus_4     = pc_current + 32'd4;
assign branch_target = pc_current + imm;
assign jal_target    = pc_current + imm;

// jalr target = (rs1 + imm) & ~1
assign jalr_target   = (rs1_data + imm) & 32'hffff_fffe;

assign pc_next = is_jal                      ? jal_target    :
                 is_jalr                     ? jalr_target   :
                 (is_branch && branch_taken) ? branch_target :
                                               pc_plus_4;

// ============================================================
// Modules
// ============================================================

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

imm_gen u_imm_gen (
    .inst   (inst),
    .opcode (opcode),
    .imm    (imm)
);

regfile u_regfile (
    .clk       (clk),
    .rst       (rst),
    .rs1       (rs1),
    .rs2       (rs2),
    .rd        (rd),
    .reg_write (reg_write),
    .wb_data   (wb_data),
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
    .operand_b  (alu_operand_b),
    .alu_ctrl   (alu_ctrl),
    .alu_result (alu_result)
);

data_mem u_data_mem (
    .clk        (clk),
    .rst        (rst),
    .mem_write  (mem_write),
    .funct3     (funct3),
    .addr       (alu_result),
    .write_data (rs2_data),
    .read_data  (mem_read_data)
);

wb_mux u_wb_mux (
    .wb_sel        (wb_sel),
    .alu_result    (alu_result),
    .mem_read_data (mem_read_data),
    .pc_plus_4     (pc_plus_4),
    .wb_data       (wb_data)
);

branch_comp u_branch_comp (
    .rs1_data      (rs1_data),
    .rs2_data      (rs2_data),
    .funct3        (funct3),
    .branch_taken  (branch_taken)
);

endmodule
