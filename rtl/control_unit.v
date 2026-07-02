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
    always @(*) begin
        case(opcode)
            

            default: begin
                reg_write = 1'b0;
                alu_src = 1'b0;
                mem_write = 1'b0;
                wb_sel = 2'b0;
                is_branch = 1'b0;
                is_jal = 1'b0;
                is_jalr = 1'b0;
                branch_taken = 1'b0;
            end
        endcase

        
    end


endmodule