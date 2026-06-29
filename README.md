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