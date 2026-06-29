`include "define.v"

module regfile(
    input  wire                         clk,
    input  wire                         rst,

    input  wire [`REG_ADDR_WIDTH-1:0]   rs1,
    input  wire [`REG_ADDR_WIDTH-1:0]   rs2,
    input  wire [`REG_ADDR_WIDTH-1:0]   rd,

    input  wire                         reg_write,
    input  wire [`DATA_WIDTH-1:0]       wb_data,

    output wire [`DATA_WIDTH-1:0]       rs1_data,
    output wire [`DATA_WIDTH-1:0]       rs2_data
);

reg [`DATA_WIDTH-1:0] regs [0:31];

integer i;

always @(posedge clk) begin
    if (rst) begin //reset x0 ~ x31
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] <= 32'b0;
        end
    end
    else begin
        if (reg_write && rd != 5'd0) begin
            regs[rd] <= wb_data;
        end
    end
end

// return 0 if access $x0 register
assign rs1_data = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
assign rs2_data = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

endmodule
