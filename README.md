此專案目標為學習 RISC-V 32 的硬體實作，預期順序：
1. R-Type
2. I-Type
3. Load/Store
4. Branch
5. Jump


## 1. 支援 R-Type
預期實作 module
cpu.v
pc.v
inst_mem.v
regfile.v
decoder.v
alu.v
control_unit.v

### MILESTORE 1

Finshed CPU and testbench

support R-Type add & sub instruction

Test case:

```
//Preload register value:
//x1 : 32'd10
//x2 : 32'd25

//Test program
add x3, x1, x2
sub x4, x2, x1

```

- Got correct result
```
x1 = 10
x2 = 25
x3 = 35
x4 = 15
```

## MILESTORE 2

Finished R-Type instrunction, inclusing:

```
add
sub
and
or
xor
slt
sltu
sll
srl
sra
```

run test patterns:
make run TEST=R_type_basic

## 2. 支援 I-type 指令

要把 I type 指令 dataflow 加上去，
實作了 imm_gen, 以及 alu operand_b mux 來決定 operand_b 是 rs2_data 還是 imm

測試程式
```
    addi x1,  x0, 10      # x1 = 10
    addi x2,  x0, 3       # x2 = 3

    addi x3,  x1, 5       # x3 = 15
    andi x4,  x1, 3       # x4 = 10 & 3 = 2
    ori  x5,  x1, 3       # x5 = 10 | 3 = 11
    xori x6,  x1, 3       # x6 = 10 ^ 3 = 9

    slti  x7, x2, 10      # x7 = 1
    sltiu x8, x2, 10      # x8 = 1

    slli x9,  x1, 3       # x9  = 80
    srli x10, x1, 3       # x10 = 1

    addi x11, x0, -8      # x11 = 0xfffffff8
    srai x12, x11, 1      # x12 = 0xfffffffc
```

result

```
[ OK  ] x0 = 0x00000000
[ OK  ] x1 = 0x0000000a
[ OK  ] x2 = 0x00000003
[ OK  ] x3 = 0x0000000f
[ OK  ] x4 = 0x00000002
[ OK  ] x5 = 0x0000000b
[ OK  ] x6 = 0x00000009
[ OK  ] x7 = 0x00000001
[ OK  ] x8 = 0x00000001
[ OK  ] x9 = 0x00000050
[ OK  ] x10 = 0x00000001
[ OK  ] x11 = 0xfffffff8
[ OK  ] x12 = 0xfffffffc
[ OK  ] x13 = 0x00000000
[ OK  ] x14 = 0x00000000
[ OK  ] x15 = 0x00000000
[ OK  ] x16 = 0x00000000
[ OK  ] x17 = 0x00000000
[ OK  ] x18 = 0x00000000
[ OK  ] x19 = 0x00000000
[ OK  ] x20 = 0x00000000
[ OK  ] x21 = 0x00000000
[ OK  ] x22 = 0x00000000
[ OK  ] x23 = 0x00000000
[ OK  ] x24 = 0x00000000
[ OK  ] x25 = 0x00000000
[ OK  ] x26 = 0x00000000
[ OK  ] x27 = 0x00000000
[ OK  ] x28 = 0x00000000
[ OK  ] x29 = 0x00000000
[ OK  ] x30 = 0x00000000
[ OK  ] x31 = 0x00000000
```

run test patterns:
make run TEST=I_type_basic 

## MILESTORE 3 LOAD/STORE 指令

修改 imm_gen, 計算出 load / store 需要的 address

新增 data_mem

新增 writeback, mux 區分原本的 alu write back 以及 load 需要的 wb_mem

run test patterns:
make run TEST=load_store