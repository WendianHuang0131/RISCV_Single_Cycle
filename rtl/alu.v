`include "define.v"

module alu(
    input  wire [`DATA_WIDTH-1:0] operand_a,
    input  wire [`DATA_WIDTH-1:0] operand_b,
    input  wire [3:0]             alu_ctrl,

    output reg  [`DATA_WIDTH-1:0] alu_result
);

always @(*) begin
    case (alu_ctrl)
        `ALU_ADD : alu_result = operand_a + operand_b;
        `ALU_SUB : alu_result = operand_a - operand_b;

        `ALU_AND : alu_result = operand_a & operand_b;
        `ALU_OR  : alu_result = operand_a | operand_b;
        `ALU_XOR : alu_result = operand_a ^ operand_b;

        `ALU_SLT : alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
        `ALU_SLTU: alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;

        `ALU_SLL : alu_result = operand_a << operand_b[4:0];
        `ALU_SRL : alu_result = operand_a >> operand_b[4:0];
        `ALU_SRA : alu_result = $signed(operand_a) >>> operand_b[4:0];

        default  : alu_result = {`DATA_WIDTH{1'b0}};
    endcase
end

endmodule
