`timescale 1ns/1ps
`include "define.v"

module pc(
    input wire                      clk,
    input wire                      rst,
    input wire   [`ADDR_WIDTH-1:0]  pc_next,

    output reg  [`ADDR_WIDTH-1:0]   pc
);

always @(posedge clk) begin
    if(rst) begin
        pc <= 32'b0;
    end
    else begin
        pc <= pc_next;
    end


end

endmodule
