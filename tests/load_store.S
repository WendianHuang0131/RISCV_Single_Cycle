.section .text
.global _start

_start:
    addi x1, x0, 0       # base address = 0
    addi x2, x0, 123     # data = 123

    sw   x2, 0(x1)       # mem[0] = 123
    lw   x3, 0(x1)       # x3 = mem[0]

    addi x4, x0, 16      # base address = 16
    addi x5, x0, -1      # data = 0xffffffff

    sw   x5, 0(x4)       # mem[16] = 0xffffffff
    lw   x6, 0(x4)       # x6 = 0xffffffff

    lw   x7, 0(x1)       # x7 = 123