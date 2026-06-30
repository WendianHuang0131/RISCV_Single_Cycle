.section .text
.global _start

_start:
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