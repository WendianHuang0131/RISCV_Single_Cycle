`timescale 1ns/1ps

module tb_cpu;

reg clk;
reg rst;

cpu dut (
    .clk(clk),
    .rst(rst)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    // preload register values after reset
    dut.u_regfile.regs[1] = 32'd10;
    dut.u_regfile.regs[2] = 32'd25;

    // run several cycles
    #50;
    // test program
    // add x3, x1, x2
    // sub x4, x2, x1
    $display("x1 = %0d", dut.u_regfile.regs[1]);
    $display("x2 = %0d", dut.u_regfile.regs[2]);
    $display("x3 = %0d", dut.u_regfile.regs[3]);
    $display("x4 = %0d", dut.u_regfile.regs[4]);

    if (dut.u_regfile.regs[3] == 32'd35 &&
        dut.u_regfile.regs[4] == 32'd15) begin
        $display("PASS");
    end
    else begin
        $display("FAIL");
    end

    $finish;
end

endmodule