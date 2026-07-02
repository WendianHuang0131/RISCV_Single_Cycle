.section .text
.global _start

_start:
    # ------------------------------------------------------------
    # Test JAL
    # PC = 0
    # jal x5, label1
    # x5 = PC + 4 = 4
    # PC = label1
    # ------------------------------------------------------------
    jal  x5, label1

    # should be skipped
    addi x1, x0, 1

label1:
    addi x2, x0, 2

    # ------------------------------------------------------------
    # Prepare JALR target
    #
    # Current PC = 12
    # jal x7, get_target
    # x7 = PC + 4 = 16
    # get_target is at PC = 24
    #
    # x7 will contain address of jalr_target
    # ------------------------------------------------------------
    jal  x7, get_target

jalr_target:
    addi x8, x0, 8

    # jump to done, avoid falling through to get_target again
    jal  x0, done

get_target:
    # ------------------------------------------------------------
    # Test JALR
    #
    # Current PC = 24
    # jalr x6, 0(x7)
    # x6 = PC + 4 = 28
    # PC = x7 + 0 = 16
    #
    # It jumps to jalr_target
    # ------------------------------------------------------------
    jalr x6, 0(x7)

    # should be skipped
    addi x9, x0, 9

done:
    addi x10, x0, 10