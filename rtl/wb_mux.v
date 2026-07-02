`include "define.v"

module wb_mux(
    input  wire [1:0]               wb_sel,
    input  wire [`DATA_WIDTH-1:0]   alu_result,
    input  wire [`DATA_WIDTH-1:0]   mem_read_data,
    input  wire [`DATA_WIDTH-1:0]   pc_plus_4,

    output reg  [`DATA_WIDTH-1:0]   wb_data
);

always @(*) begin
    case (wb_sel)
        `WB_ALU:  wb_data = alu_result;
        `WB_MEM:  wb_data = mem_read_data;
        `WB_PC4:  wb_data = pc_plus_4;
        default:  wb_data = {`DATA_WIDTH{1'b0}};
    endcase
end

endmodule
