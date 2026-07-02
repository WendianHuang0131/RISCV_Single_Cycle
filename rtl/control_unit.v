`include "define.v"

module control_unit(
    input  wire [6:0] opcode,

    output reg        reg_write,
    output reg        mem_write,
    output reg        alu_src,
    output reg [1:0]  wb_sel,

    output reg        is_branch,
    output reg        is_jal,
    output reg        is_jalr
);

    always @(*) begin
        // default values
        reg_write = 1'b0;
        mem_write = 1'b0;
        alu_src   = 1'b0;
        wb_sel    = `WB_ALU;

        is_branch = 1'b0;
        is_jal    = 1'b0;
        is_jalr   = 1'b0;

        case (opcode)
            `OPCODE_R: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                wb_sel    = `WB_ALU;
            end

            `OPCODE_I: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                wb_sel    = `WB_ALU;
            end

            `OPCODE_LOAD: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                wb_sel    = `WB_MEM;
            end

            `OPCODE_STORE: begin
                reg_write = 1'b0;
                mem_write = 1'b1;
                alu_src   = 1'b1;
            end

            `OPCODE_BRANCH: begin
                reg_write = 1'b0;
                mem_write = 1'b0;
                alu_src   = 1'b0;
                is_branch = 1'b1;
            end

            `OPCODE_JAL: begin
                reg_write = 1'b1;
                wb_sel    = `WB_PC4;
                is_jal    = 1'b1;
            end

            `OPCODE_JALR: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                wb_sel    = `WB_PC4;
                is_jalr   = 1'b1;
            end

            default: begin
                reg_write = 1'b0;
                mem_write = 1'b0;
                alu_src   = 1'b0;
                wb_sel    = `WB_ALU;
                is_branch = 1'b0;
                is_jal    = 1'b0;
                is_jalr   = 1'b0;
            end
        endcase
    end

endmodule
