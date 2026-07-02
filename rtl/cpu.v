`include "define.v"

module cpu(
    input wire clk,
    input wire rst
);

// ============================================================
// IF stage / PC / Instruction
// ============================================================

wire [`ADDR_WIDTH-1:0] pc_current;
wire [`ADDR_WIDTH-1:0] pc_next;
wire [`ADDR_WIDTH-1:0] pc_plus_4;

wire [`INST_WIDTH-1:0] inst;

// ============================================================
// Decoded instruction fields
// ============================================================

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;

wire [`REG_ADDR_WIDTH-1:0] rs1;
wire [`REG_ADDR_WIDTH-1:0] rs2;
wire [`REG_ADDR_WIDTH-1:0] rd;

// ============================================================
// Register file / Immediate
// ============================================================

wire [`DATA_WIDTH-1:0] rs1_data;
wire [`DATA_WIDTH-1:0] rs2_data;
wire [`DATA_WIDTH-1:0] imm;

// ============================================================
// Control signals
// ============================================================

wire        reg_write;
wire        mem_write;
wire        alu_src;
wire [1:0]  wb_sel;

wire        is_branch;
wire        is_jal;
wire        is_jalr;
wire        branch_taken;

// ============================================================
// ALU / Memory / Writeback
// ============================================================

wire [3:0] alu_ctrl;

wire [`DATA_WIDTH-1:0] alu_operand_b;
wire [`DATA_WIDTH-1:0] alu_result;

wire [`DATA_WIDTH-1:0] mem_read_data;
wire [`DATA_WIDTH-1:0] wb_data;

// ============================================================
// PC target calculation
// ============================================================

wire [`ADDR_WIDTH-1:0] branch_target;
wire [`ADDR_WIDTH-1:0] jal_target;
wire [`ADDR_WIDTH-1:0] jalr_target;

// ============================================================
// Control Unit
// ============================================================

control_unit u_control_unit (
    .opcode    (opcode),

    .reg_write (reg_write),
    .mem_write (mem_write),
    .alu_src   (alu_src),
    .wb_sel    (wb_sel),

    .is_branch (is_branch),
    .is_jal    (is_jal),
    .is_jalr   (is_jalr)
);

// ============================================================
// Datapath combinational logic
// ============================================================

assign pc_plus_4 = pc_current + 32'd4;

assign branch_target = pc_current + imm;
assign jal_target    = pc_current + imm;

// RISC-V JALR target must clear bit 0
assign jalr_target = (rs1_data + imm) & 32'hffff_fffe;

assign pc_next = is_jal                      ? jal_target    :
                 is_jalr                     ? jalr_target   :
                 (is_branch && branch_taken) ? branch_target :
                                               pc_plus_4;

assign alu_operand_b = alu_src ? imm : rs2_data;

// ============================================================
// PC
// ============================================================

pc u_pc (
    .clk     (clk),
    .rst     (rst),
    .pc_next (pc_next),
    .pc      (pc_current)
);

// ============================================================
// Instruction Memory
// ============================================================

inst_mem u_inst_mem (
    .addr (pc_current),
    .inst (inst)
);

// ============================================================
// Decoder
// ============================================================

decoder u_decoder (
    .inst   (inst),
    .opcode (opcode),
    .rd     (rd),
    .funct3 (funct3),
    .rs1    (rs1),
    .rs2    (rs2),
    .funct7 (funct7)
);

// ============================================================
// Immediate Generator
// ============================================================

imm_gen u_imm_gen (
    .inst   (inst),
    .opcode (opcode),
    .imm    (imm)
);

// ============================================================
// Register File
// ============================================================

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

// ============================================================
// ALU Control
// ============================================================

alu_control u_alu_control (
    .opcode   (opcode),
    .funct7   (funct7),
    .funct3   (funct3),
    .alu_ctrl (alu_ctrl)
);

// ============================================================
// ALU
// ============================================================

alu u_alu (
    .operand_a  (rs1_data),
    .operand_b  (alu_operand_b),
    .alu_ctrl   (alu_ctrl),
    .alu_result (alu_result)
);

// ============================================================
// Branch Comparator
// ============================================================

branch_comp u_branch_comp (
    .rs1_data     (rs1_data),
    .rs2_data     (rs2_data),
    .funct3       (funct3),
    .branch_taken (branch_taken)
);

// ============================================================
// Data Memory
// ============================================================

data_mem u_data_mem (
    .clk        (clk),
    .rst        (rst),
    .mem_write  (mem_write),
    .funct3     (funct3),
    .addr       (alu_result),
    .write_data (rs2_data),
    .read_data  (mem_read_data)
);

// ============================================================
// Writeback Mux
// ============================================================

wb_mux u_wb_mux (
    .wb_sel        (wb_sel),
    .alu_result    (alu_result),
    .mem_read_data (mem_read_data),
    .pc_plus_4     (pc_plus_4),
    .wb_data       (wb_data)
);

endmodule
