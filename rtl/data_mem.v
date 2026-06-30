`include "define.v"

module data_mem(
    input  wire                    clk,
    input  wire                    rst,

    input  wire                    mem_write,
    input  wire [`ADDR_WIDTH-1:0]  addr,
    input  wire [`DATA_WIDTH-1:0]  write_data,

    output wire [`DATA_WIDTH-1:0]  read_data
);

    reg [`DATA_WIDTH-1:0] mem [0:255];

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1) begin
                mem[i] <= {`DATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (mem_write) begin
                mem[addr[9:2]] <= write_data;
            end
        end
    end

    assign read_data = mem[addr[9:2]];

endmodule