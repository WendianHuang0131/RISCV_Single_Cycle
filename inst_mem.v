`include "define.v"
// input addr, output instruction
module inst_mem(
    input  wire [`ADDR_WIDTH-1:0] addr,
    output wire [`INST_WIDTH-1:0] inst
);
    //TODO: add inst mem size in define.v
    reg [`INST_WIDTH-1:0] mem [0:255];

    assign inst = mem[addr[9:2]]; // byte address to word address


endmodule
