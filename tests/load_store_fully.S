.section .text
.global _start

_start:
    addi x1, x0, 0        # base addr = 0
    addi x2, x0, -1       # x2 = 0xffffffff

    sw   x2, 0(x1)

    lb   x3, 0(x1)        # 0xffffffff
    lbu  x4, 0(x1)        # 0x000000ff

    lh   x5, 0(x1)        # 0xffffffff
    lhu  x6, 0(x1)        # 0x0000ffff

    lw   x7, 0(x1)        # 0xffffffff

    addi x8, x0, 0x12
    sb   x8, 4(x1)
    lbu  x9, 4(x1)        # 0x00000012

    addi x10, x0, 0x34
    sh   x10, 8(x1)
    lhu  x11, 8(x1)       # 0x00000034