`include "define.v"

module alu(
    input  wire [`DATA_WIDTH-1:0] operand_a,
    input  wire [`DATA_WIDTH-1:0] operand_b,
    input  wire [3:0]             alu_ctrl,

    output reg  [`DATA_WIDTH-1:0] alu_result
);

always @(*) begin
    case (alu_ctrl)
        `ALU_ADD: alu_result = operand_a + operand_b;
        `ALU_SUB: alu_result = operand_a - operand_b;
        default : alu_result = 32'b0;
    endcase
end

endmodule
