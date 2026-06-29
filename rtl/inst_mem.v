`include "define.v"
// input addr, output instruction
module inst_mem(
    input  wire [`ADDR_WIDTH-1:0] addr,
    output wire [`INST_WIDTH-1:0] inst
);
    //TODO: add inst mem size in define.v
    reg [`INST_WIDTH-1:0] mem [0:255];

    //load test program
    initial begin
        // add x3, x1, x2
        // sub x4, x2, x1
        $readmemh("./program/add_sub.hex", mem);
    end

    assign inst = mem[addr[9:2]]; // byte address to word address


endmodule
