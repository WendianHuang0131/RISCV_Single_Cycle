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