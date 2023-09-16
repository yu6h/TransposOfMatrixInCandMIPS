.data
    A: .space  36
    transposeOfA1: .space 36
    transposeOfA2: .space 36
.text
    main:
        la $s0,A                #s0 = A[3][3]
        la $s1,transposeOfA1    #s1 = transposeOfA1[3][3]
        la $s2,transposeOfA2    #s2 = transposeOfA2[3][3]

        move $a0,$s0
        jal inputMatrix

        move $a0,$s0
        move $a1,$s1
        li $a2,3
        jal transposeMatrixA1

        move $a0,$s0
        move $a1,$s2
        li $a2,3
        jal transposeMatrixA2

        move $a1,$s1
        jal outputMatrix

        move $a1,$s2
        jal outputMatrix
    
    # Tell the system that the program is done.
    li $v0, 10
    syscall

    inputMatrix:
        # addr = baseAddr + (rowIndex * colSize + colIndex)*datasize
        move $t0,$zero # i = 0
        for1InputMatrix:
            bge $t0,3,exitfor1InputMatrix
            move $t1,$zero # j = 0
                for2InputMatrix:
                    bge $t1,3,exitfor2InputMatrix
                    mul $t4,$t0,3
                    add $t4,$t4,$t1
                    mul $t4,$t4,4
                    add $t4,$t4,$a0

                    li $v0,5
                    syscall

                    sw $v0,0($t4)

                    addi $t1,$t1,1
                    j for2InputMatrix
                exitfor2InputMatrix:
            addi $t0,$t0,1
            j for1InputMatrix
        exitfor1InputMatrix:
    jr $ra

    transposeMatrixA2:
        move $t0,$a0    #ptrB = B
        move $t1,$a1    #ptrT = T
        li $t2,1        # i =1
        forTransposeMatrixA2:
            mul $t3,$a2,$a2
            sll $t3,$t3,2           #t3*=4
            add $t3,$t3,$a0         #t3 = (B + (size * size)
            bge $t0,$t3,exitForTransposeMatrixA2

            #*ptrT = *ptrB
            lw $t3,0($t0)
            sw $t3,0($t1)

            bge $t2,$a2,L1
                sll $t3,$a2,2
                add $t1,$t1,$t3     #ptrT += size
                addi $t2,$t2,1      #i++
                j L2
            L1:
                subi $t3,$a2,1
                mul  $t3,$t3,$a2
                subi $t3,$t3,1          #$t3 = (size * (size - 1) - 1)
                sll $t3,$t3,2           #$t3 *= 4
                sub $t1,$t1,$t3         #prtT -= (size * (size - 1) - 1)
                li $t2,1                #i = 1
            L2:
            addi $t0,$t0,4 #ptrB++
            j forTransposeMatrixA2
        exitForTransposeMatrixA2:
    jr $ra
    transposeMatrixA1:
        move $t0,$zero # i = 0
        for1TransposeMatrixA1:
            bge $t0,$a2,exitfor1TransposeMatrixA1
            move $t1,$zero # j = 0
                for2TransposeMatrixA1:
                    bge $t1,$a2,exitfor2TransposeMatrixA1

                    mul $t3,$t0,$a2
                    add $t3,$t3,$t1
                    mul $t3,$t3,4
                    add $t3,$t3,$a0 #t3 = A[i][j] address

                    mul $t4,$t1,$a2
                    add $t4,$t4,$t0
                    mul $t4,$t4,4
                    add $t4,$t4,$a1 #t4 = T[i][j] address

                    lw $t5,0($t3)
                    sw $t5,0($t4)

                    addi $t1,$t1,1
                    j for2TransposeMatrixA1
                exitfor2TransposeMatrixA1:
            addi $t0,$t0,1
            j for1TransposeMatrixA1
        exitfor1TransposeMatrixA1:
    jr $ra

    outputMatrix:
        move $t0,$zero
        for1OutputMatrix:
            bge $t0,3,exitFor1OutputMatrix
            move $t1,$zero
            for2OutputMatrix:
                bge $t1,3,exitFor2OutputMatrix

                mul $t3,$t0,3
                add $t3,$t3,$t1
                mul $t3,$t3,4
                add $t3,$t3,$a1 #t3 = A[i][j] address

                lw $a0,0($t3)
                li $v0,1
                syscall

                # print space, 32 is ASCII code for space
                li $a0, 32
                li $v0, 11  # syscall number for printing character
                syscall

                addi $t1,$t1,1
                j for2OutputMatrix
            exitFor2OutputMatrix:
            #印出換行
            addi $a0, $0, 0xA
            addi $v0, $0, 0xB
            syscall
            addi $t0,$t0,1
            j for1OutputMatrix
        exitFor1OutputMatrix:
    jr $ra