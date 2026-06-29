`define "define.v"

// input addr, output instruction

module inst_mem(
    input wire                      clk,
    input wire                      rst,
    input wire  [`ADDR_WIDTH-1:0]   addr,

    output reg  [`INST_WIDTH-1:0]   inst
);
    //TODO: add inst mem size in "define.v"
    reg [`INST_WIDTH-1] mem [0:255];

    always @(posedge clk) begin
        if(rst) begin
            inst <= 32'b0;
        end
        else begin
            inst <= mem[addr >> 2];
        end
    end


endmodule