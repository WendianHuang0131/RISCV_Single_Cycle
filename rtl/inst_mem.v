`include "define.v"

// input addr, output instruction

module inst_mem(
    input  wire [`ADDR_WIDTH-1:0] addr,
    output wire [`INST_WIDTH-1:0] inst
);

    // TODO: add inst mem size in define.v
    reg [`INST_WIDTH-1:0] mem [0:255];

    // Use reg instead of string for Verilog compatibility
    reg [1023:0] hex_file;

    initial begin
        if (!$value$plusargs("HEX=%s", hex_file)) begin
            hex_file = "program/alu_basic.hex";
        end

        $display("[INST_MEM] Loading program: %0s", hex_file);
        $readmemh(hex_file, mem);
    end

    assign inst = mem[addr[9:2]]; // byte address to word address

endmodule
