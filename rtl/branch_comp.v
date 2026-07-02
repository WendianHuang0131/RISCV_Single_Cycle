`include "define.v"

module branch_comp(
    input  wire [`DATA_WIDTH-1:0] rs1_data,
    input  wire [`DATA_WIDTH-1:0] rs2_data,
    input  wire [2:0]             funct3,

    output reg                    branch_taken
);

always @(*) begin
    case (funct3)
        3'b000: branch_taken = (rs1_data == rs2_data);                          // beq
        3'b001: branch_taken = (rs1_data != rs2_data);                          // bne
        3'b100: branch_taken = ($signed(rs1_data) <  $signed(rs2_data));         // blt
        3'b101: branch_taken = ($signed(rs1_data) >= $signed(rs2_data));         // bge
        3'b110: branch_taken = (rs1_data < rs2_data);                           // bltu
        3'b111: branch_taken = (rs1_data >= rs2_data);                          // bgeu
        default: branch_taken = 1'b0;
    endcase
end

endmodule