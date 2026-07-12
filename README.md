# RV32I CPU Implementation

這個專案使用 Verilog/SystemVerilog 實作一個 **RISC-V 32-bit CPU（RV32I subset）**。

開發方式採用循序漸進的 datapath 擴充流程，先完成 single-cycle CPU，再逐步加入 5-stage pipeline、data hazard handling、forwarding、load-use stall 與 control hazard flush。

---

## Project Goals

本專案的主要目標：

1. 熟悉 RV32I instruction encoding 與 datapath
2. 從零建立 single-cycle CPU
3. 按 instruction type 逐步擴充功能
4. 建立 assembly test flow 與 register golden checking
5. 將 single-cycle CPU 改造成 5-stage pipeline CPU
6. 實作 hazard detection、stall、forwarding 與 flush

---

## Note

[HACKMD: Single-cycle RISC-V 32 Implementation](https://hackmd.io/@qMrp9BNDQ0Gf2uuTTGde-A/SyRdXZy4Gx)

---

## Supported Instruction Types

目前 single-cycle baseline 依照以下順序完成：

1. R-type
2. I-type ALU
3. Load / Store
4. B-type
5. J-type / JALR

目前支援的 instruction：

| Type | Instructions |
|---|---|
| R-type | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| I-type ALU | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` |
| Load | `LB`, `LH`, `LW`, `LBU`, `LHU` |
| Store | `SB`, `SH`, `SW` |
| B-type | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| Jump | `JAL`, `JALR` |

> 目前實作的是 RV32I subset，尚未包含 `LUI`、`AUIPC`、CSR、`FENCE`、`ECALL`、`EBREAK` 等 instruction。

---

# Development Milestones

## Milestone 1 — R-type Datapath

完成 register-to-register ALU datapath。

### Features

- Instruction decode
- Register file with 2 read ports and 1 write port
- ALU control
- ALU operation
- Register write-back
- Assembly test flow
- Register preload and expected-result checking

### Supported Instructions

```text
ADD
SUB
SLL
SLT
SLTU
XOR
SRL
SRA
OR
AND
```

### Main Commits

```text
35a9990f  [MILESTORE] Finished R-Type add, sub instruction
ef795da9  [MILESTORE] Finished R-type instructions, tb, test flow
```

### Test Cases

```text
alu_basic
r_type
```

Recommended coverage:

```assembly
add  x3,  x1, x2
sub  x4,  x1, x2
and  x6,  x1, x2
or   x7,  x1, x2
xor  x8,  x1, x2
slt  x9,  x2, x1
sltu x10, x2, x1
sll  x11, x1, x2
srl  x12, x1, x2
sra  x13, x5, x2
```

---

## Milestone 2 — I-type ALU Datapath

加入 immediate generator 與 ALU operand B mux，使 ALU 可以選擇 register data 或 immediate。

### Features

- I-type immediate generation
- 12-bit immediate sign extension
- ALU operand B selection
- Shift-immediate decoding
- I-type ALU write-back

### Supported Instructions

```text
ADDI
SLTI
SLTIU
XORI
ORI
ANDI
SLLI
SRLI
SRAI
```

### Main Commit

```text
5d6b442f  [MILESTORE] Finished I-type instructions
```

### Test Cases

```text
i_type
i_type_basic
```

---

## Milestone 3 — Load / Store Datapath

加入 Data Memory、effective address calculation 與 memory write-back path。

### Features

- Effective address calculation: `address = rs1 + immediate`
- Byte-addressable Data Memory
- Little-endian memory layout
- Signed and unsigned load
- Byte, halfword and word store
- Write-back mux supports ALU and memory result

### Supported Instructions

```text
LB
LH
LW
LBU
LHU
SB
SH
SW
```

### Main Commits

```text
eb6d0a71  [MILESTORE] Finished load/store datapath
b824a054  [MILESTORE] finished fully load/store instruction
```

### Test Cases

```text
load_store
load
store
lb_lbu
lh_lhu
```

---

## Milestone 4 — B-type Datapath

加入 branch comparator、B-type immediate encoding 與 conditional next-PC selection。

### Features

- Branch immediate generation
- Branch target calculation: `branch_target = PC + immediate`
- Signed comparison
- Unsigned comparison
- Conditional PC selection

### Supported Instructions

```text
BEQ
BNE
BLT
BGE
BLTU
BGEU
```

### Main Commit

```text
4c1933bc  [MILESTONE] Implemented B-type datapath
```

### Test Case

```text
branch
```

---

## Milestone 5 — J-type / Jump Datapath

加入 JAL、JALR target calculation 與 `PC+4` write-back path。

### Features

- J-type immediate generation
- JAL target calculation: `jal_target = PC + immediate`
- JALR target calculation: `jalr_target = (rs1 + immediate) & ~1`
- Write-back mux supports `PC+4`
- Function call and return style control flow

### Supported Instructions

```text
JAL
JALR
```

### Main Commit

```text
e20f3428  [MILESTONE] Implement j-type datapath
```

### Test Cases

```text
jal
jalr
```

---

# Single-Cycle CPU Architecture

Single-cycle CPU 在一個 clock cycle 內完成一條 instruction：

```text
PC
→ Instruction Memory
→ Decoder
→ Register File
→ Immediate Generator
→ ALU / Branch Comparator
→ Data Memory
→ Write-back Mux
→ Register File
```

## Characteristics

### Advantages

- Datapath concept is straightforward
- CPI is always 1
- No pipeline data hazard
- No forwarding or stall logic required
- Easy to verify instruction functionality

### Limitations

- Long critical path
- Clock period is limited by the slowest instruction
- Load instruction usually determines the minimum clock period
- Hardware resources cannot be overlapped across instructions

---

# Project Structure

```text
.
├── rtl/
│   ├── cpu.v
│   ├── pc.v
│   ├── inst_mem.v
│   ├── data_mem.v
│   ├── regfile.v
│   ├── decoder.v
│   ├── imm_gen.v
│   ├── control_unit.v
│   ├── alu_control.v
│   ├── alu.v
│   ├── branch_comp.v
│   ├── wb_mux.v
│   ├── forwarding_unit.v
│   ├── hazard_unit.v
│   ├── if_id_reg.v
│   ├── id_ex_reg.v
│   ├── ex_mem_reg.v
│   └── mem_wb_reg.v
├── tests/
│   ├── preload_data/
│   ├── expected_result/
│   └── *.S
├── build/
├── program/
├── tb_top.sv
├── Makefile
└── README.md
```

> 請依實際 repository 目錄調整上述 tree。

---

# Test Flow

```text
tests/*.S
   ↓
RISC-V GCC
   ↓
ELF
   ↓
objcopy
   ↓
BIN
   ↓
HEX
   ↓
Instruction Memory preload
   ↓
RTL simulation
   ↓
Register result comparison
```

The testbench supports:

- Register preload
- Expected register result checking
- Test selection through command-line arguments
- VCD waveform dump
- Regression test flow

---

# Build and Run

Run the default testcase:

```bash
make test
```

Run a specific testcase:

```bash
make test TEST=alu_basic
```

Run with a custom simulation cycle count:

```bash
make test TEST=branch SIM_CYCLES=100
```

Open waveform:

```bash
make wave TEST=branch
```

Clean generated files:

```bash
make clean
```

> Target names may be adjusted according to the actual Makefile.

---

# Verification Checklist

Each testcase should verify:

- Correct source register values
- Correct immediate encoding
- Correct ALU operation
- Correct destination register
- Correct memory address
- Correct load sign/zero extension
- Correct store byte enable behavior
- Correct branch taken/not-taken result
- Correct JAL/JALR target
- Correct `PC+4` link address
- Correct forwarding source
- Correct load-use stall
- Wrong-path instructions produce no architectural side effects

---

# Tools

```text
Verilator
GTKWave
RISC-V GNU Toolchain
GNU Make
macOS / Linux
```

---

# Current Status

The project currently contains:

- RV32I single-cycle CPU baseline
- R-type, I-type, Load/Store, B-type, JAL and JALR support
- Assembly-based test flow
- Register preload and golden-result checking
- 5-stage pipeline datapath
- RAW hazard detection
- EX/MEM and MEM/WB forwarding
- Load-use interlock
- Branch/JAL/JALR redirect and pipeline flush

---

# Future Work

- `LUI` and `AUIPC`
- CSR instructions
- Exception and interrupt handling
- `ECALL` and `EBREAK`
- Branch prediction
- Pipeline valid bits
- Memory ready/valid protocol
- Cache integration
- Formal verification
- Functional coverage
- Performance counters

---

# Notes

This project is intended for learning CPU microarchitecture, RISC-V instruction execution, pipelining and hazard handling. It is not a complete production-grade RISC-V core.