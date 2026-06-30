`include "define.v"

module alu_control(
    input wire [6:0] opcode,
    input wire [6:0] funct7,
    input wire [2:0] funct3,

    output reg [3:0] alu_ctrl
);

always @(*) begin
    alu_ctrl = `ALU_ADD;

    case (opcode)
        `OPCODE_R: begin
            case ({funct7, funct3})
                {7'b0000000, 3'b000}: alu_ctrl = `ALU_ADD;
                {7'b0100000, 3'b000}: alu_ctrl = `ALU_SUB;
                {7'b0000000, 3'b111}: alu_ctrl = `ALU_AND;
                {7'b0000000, 3'b110}: alu_ctrl = `ALU_OR;
                {7'b0000000, 3'b100}: alu_ctrl = `ALU_XOR;
                {7'b0000000, 3'b010}: alu_ctrl = `ALU_SLT;
                {7'b0000000, 3'b011}: alu_ctrl = `ALU_SLTU;
                {7'b0000000, 3'b001}: alu_ctrl = `ALU_SLL;
                {7'b0000000, 3'b101}: alu_ctrl = `ALU_SRL;
                {7'b0100000, 3'b101}: alu_ctrl = `ALU_SRA;
                default              : alu_ctrl = `ALU_ADD;
            endcase
        end

        `OPCODE_I: begin
            case (funct3)
                3'b000: alu_ctrl = `ALU_ADD;   // addi
                3'b111: alu_ctrl = `ALU_AND;   // andi
                3'b110: alu_ctrl = `ALU_OR;    // ori
                3'b100: alu_ctrl = `ALU_XOR;   // xori
                3'b010: alu_ctrl = `ALU_SLT;   // slti
                3'b011: alu_ctrl = `ALU_SLTU;  // sltiu
                3'b001: alu_ctrl = `ALU_SLL;   // slli

                3'b101: begin
                    if (funct7 == 7'b0100000)
                        alu_ctrl = `ALU_SRA;   // srai
                    else
                        alu_ctrl = `ALU_SRL;   // srli
                end

                default: alu_ctrl = `ALU_ADD;
            endcase
        end

        default: begin
            alu_ctrl = `ALU_ADD;
        end
    endcase
end

endmodule