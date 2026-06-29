`timescale 1ns/1ps

module tb_top;

logic clk;
logic rst;

string test_name;
string vcd_file;
string preload_file;
string expect_file;

int sim_cycles;
int error_count;

logic [31:0] preload_regs [0:31];
logic [31:0] expect_regs  [0:31];

integer i;

cpu dut (
    .clk(clk),
    .rst(rst)
);

// ============================================================
// Clock generation
// ============================================================

always #5 clk = ~clk;

// ============================================================
// Plusargs and waveform
// ============================================================

initial begin
    if (!$value$plusargs("TEST=%s", test_name)) begin
        test_name = "alu_basic";
    end

    if (!$value$plusargs("VCD=%s", vcd_file)) begin
        vcd_file = "wave.vcd";
    end

    if (!$value$plusargs("PRELOAD=%s", preload_file)) begin
        preload_file = "tests/preload_data/alu_basic.hex";
    end

    if (!$value$plusargs("EXPECT=%s", expect_file)) begin
        expect_file = "tests/expected_result/alu_basic.hex";
    end

    if (!$value$plusargs("SIM_CYCLES=%d", sim_cycles)) begin
        sim_cycles = 50;
    end

    $dumpfile(vcd_file);
    $dumpvars(0, tb_top);

    $display("============================================================");
    $display("[TB] TEST       = %s", test_name);
    $display("[TB] VCD        = %s", vcd_file);
    $display("[TB] PRELOAD    = %s", preload_file);
    $display("[TB] EXPECT     = %s", expect_file);
    $display("[TB] SIM_CYCLES = %0d", sim_cycles);
    $display("============================================================");
end

// ============================================================
// Main simulation flow
// ============================================================

initial begin
    clk = 1'b0;
    rst = 1'b1;

    repeat (2) @(posedge clk);
    rst = 1'b0;

    #1;
    preload_registers();
    
    dut.u_pc.pc = 32'h0000_0000;
    repeat (sim_cycles) @(posedge clk);

    check_registers();

    if (error_count == 0) begin
        $display("============================================================");
        $display("[PASS] TEST = %s", test_name);
        $display("============================================================");
    end
    else begin
        $display("============================================================");
        $display("[FAIL] TEST = %s, error_count = %0d", test_name, error_count);
        $display("============================================================");
    end

    $finish;
end

// ============================================================
// Preload x0~x31 from tests/preload_data/<TEST>.hex
// ============================================================

task preload_registers;
begin
    $display("[TB] Loading preload registers from: %s", preload_file);

    $readmemh(preload_file, preload_regs);

    for (i = 0; i < 32; i = i + 1) begin
        dut.u_regfile.regs[i] = preload_regs[i];
    end

    // RISC-V x0 must always be zero
    dut.u_regfile.regs[0] = 32'h0000_0000;

    $display("[TB] Preload register file:");
    for (i = 0; i < 32; i = i + 1) begin
        $display("  x%0d = 0x%08h", i, dut.u_regfile.regs[i]);
    end

    $display("[TB] Preload done");
end
endtask

// ============================================================
// Check x0~x31 with tests/expected_result/<TEST>.hex
// ============================================================

task check_registers;
begin
    error_count = 0;

    $display("[TB] Loading expected registers from: %s", expect_file);

    $readmemh(expect_file, expect_regs);

    // x0 expected value should always be zero
    expect_regs[0] = 32'h0000_0000;

    $display("[TB] Checking register file...");

    for (i = 0; i < 32; i = i + 1) begin
        if (dut.u_regfile.regs[i] !== expect_regs[i]) begin
            $display("[ERROR] x%0d mismatch: expected=0x%08h, actual=0x%08h",
                     i, expect_regs[i], dut.u_regfile.regs[i]);
            error_count = error_count + 1;
        end
        else begin
            $display("[ OK  ] x%0d = 0x%08h", i, dut.u_regfile.regs[i]);
        end
    end
end
endtask

endmodule
