.section .text
.global _start

_start:
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