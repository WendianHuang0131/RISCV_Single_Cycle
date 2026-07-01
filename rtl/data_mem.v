`include "define.v"

module data_mem(
    input  wire                    clk,
    input  wire                    rst,

    input  wire                    mem_write,
    input  wire [2:0]              funct3,

    input  wire [`ADDR_WIDTH-1:0]  addr,
    input  wire [`DATA_WIDTH-1:0]  write_data,

    output reg  [`DATA_WIDTH-1:0]  read_data
);

    // 1KB byte-addressable memory
    reg [7:0] mem [0:1023];

    integer i;

    // write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1) begin
                mem[i] <= 8'b0;
            end
        end
        else begin
            if (mem_write) begin
                case (funct3)
                    3'b000: begin
                        // sb
                        mem[addr] <= write_data[7:0];
                    end

                    3'b001: begin
                        // sh
                        mem[addr]     <= write_data[7:0];
                        mem[addr + 1] <= write_data[15:8];
                    end

                    3'b010: begin
                        // sw
                        mem[addr]     <= write_data[7:0];
                        mem[addr + 1] <= write_data[15:8];
                        mem[addr + 2] <= write_data[23:16];
                        mem[addr + 3] <= write_data[31:24];
                    end

                    default: begin
                    end
                endcase
            end
        end
    end

    // read
    always @(*) begin
        case (funct3)
            3'b000: begin
                // lb
                read_data = {{24{mem[addr][7]}}, mem[addr]};
            end

            3'b001: begin
                // lh
                read_data = {{16{mem[addr + 1][7]}}, mem[addr + 1], mem[addr]};
            end

            3'b010: begin
                // lw
                read_data = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};
            end

            3'b100: begin
                // lbu
                read_data = {24'b0, mem[addr]};
            end

            3'b101: begin
                // lhu
                read_data = {16'b0, mem[addr + 1], mem[addr]};
            end

            default: begin
                read_data = {`DATA_WIDTH{1'b0}};
            end
        endcase
    end

endmodule
