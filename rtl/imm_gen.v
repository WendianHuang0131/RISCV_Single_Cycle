`include "define.v"

module imm_gen(
    input  wire [`INST_WIDTH-1:0] inst,
    input  wire [6:0]             opcode,

    output reg  [`DATA_WIDTH-1:0] imm
);

always @(*) begin
    case (opcode)
        `OPCODE_I: begin
            //extend imm to 32bits imm
            imm = {{20{inst[31]}}, inst[31:20]};
        end

        default: begin
            imm = {`DATA_WIDTH{1'b0}};
        end
    endcase
end

endmodule
