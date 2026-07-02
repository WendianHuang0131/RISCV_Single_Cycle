.section .text
.global _start

_start:
    addi x1, x0, 5
    addi x2, x0, 5
    addi x3, x0, 9

    beq  x1, x2, beq_taken
    addi x10, x0, 1        # should be skipped

beq_taken:
    addi x10, x0, 2        # x10 = 2

    bne  x1, x3, bne_taken
    addi x11, x0, 1        # should be skipped

bne_taken:
    addi x11, x0, 2        # x11 = 2

    blt  x1, x3, blt_taken
    addi x12, x0, 1        # should be skipped

blt_taken:
    addi x12, x0, 2        # x12 = 2

    bge  x3, x1, bge_taken
    addi x13, x0, 1        # should be skipped

bge_taken:
    addi x13, x0, 2        # x13 = 2

    bltu x1, x3, bltu_taken
    addi x14, x0, 1        # should be skipped

bltu_taken:
    addi x14, x0, 2        # x14 = 2

    bgeu x3, x1, bgeu_taken
    addi x15, x0, 1        # should be skipped

bgeu_taken:
    addi x15, x0, 2        # x15 = 2