`include "define.v"

module imm_gen(
    input  wire [`INST_WIDTH-1:0] inst,
    input  wire [6:0]             opcode,

    output reg  [`DATA_WIDTH-1:0] imm
);

always @(*) begin
    case (opcode)
        `OPCODE_I: begin
            // addi, andi, ori, xori, slti, sltiu, slli, srli, srai
            imm = {{20{inst[31]}}, inst[31:20]};
        end

        `OPCODE_LOAD: begin
            // lw: imm[11:0] = inst[31:20]
            imm = {{20{inst[31]}}, inst[31:20]};
        end

        `OPCODE_STORE: begin
            // sw: imm[11:5] = inst[31:25], imm[4:0] = inst[11:7]
            imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        end

        default: begin
            imm = {`DATA_WIDTH{1'b0}};
        end
    endcase
end

endmodule