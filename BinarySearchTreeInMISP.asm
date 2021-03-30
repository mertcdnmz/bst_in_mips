.data
# -9999 marks the end of the list
# other examples for testing your code
mylist: .word 14, 3, 68, 18, 86, 61, 78, 79, 1, 22, 10, 42, 90, 31, 56, 38, 83, 6, 62, 72, -9999
firstList: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999
secondList: .word 8, 3, 6, 6, 10, 13, 7, 4, 5, -9999
thirdList: .word 8, 3, 6, 10, 13, -9999, 7, 4, 5, -9999

hyphen: .asciiz "-"
space: .asciiz " "
newline: .asciiz "\n"
queueStart: .word 0

# assertEquals data
failf: .asciiz " failed\n"
passf: .asciiz " passed\n"
buildTest: .asciiz " Build test"
insertTest: .asciiz " Insert test"
findTest: .asciiz " Find test"
asertNumber: .word 0



.text
main:
    la $s2, thirdList


    jal build

    # Start of the test cases----------------------------------------------------
    #
    #
    # check build procedure
    lw $t0, 4($s0) # address of the left child of the root
    lw $a0, 0($t0) # real value of the left child of the root
    li $a1, 3 # expected value of the left child of the root
    la $a2, buildTest # the name of the test
    # if left child != 3 then print failed
    jal assertEquals

    # check insert procedure
    li $a0, 11 # new value to be inserted
    move $a1, $s0 # address of the root
    jal insert
    # no need to reload 11 to $a0

    lw $a1, 0($v0) # value from the returned address
    la $a2, insertTest # the name of the test
    # if returned address's value != 11 print failed
    jal assertEquals

    # check find procedure
    li $a0, 11 # search value
    move $a1, $s0 # adress of the root
    jal find
    # no need to reload 11 to $a0
    lw $a1, 0($v1) # value from the found adress
    la $a2, findTest # the name of the test
    # if returned address's value != 11 print failed
    jal assertEquals

    # check find procedure 2
    # 44 should not be on the list
    # v0 should return 1
    li $a0, 44 # search value
    move $a1, $s0 # adress of the root
    jal find
    move $a0, $v0 # result of the search
    li $a1, 1 # expected result of the search
    la $a2, findTest # the name of the test
    # if returned value of $v0 != 0 print failed
    jal assertEquals
    # End of the test cases----------------------------------------------------
    move $a0, $s0
    jal print
    # End program
    li $v0, 10
    syscall

assertEquals:
    move $t2, $a0
    # increment count of total assertions.
    la $t0, asertNumber
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    sw $t1, 0($t0)

    # print the test number
    add $a0, $t1, $zero
    li $v0, 1
    syscall

    # print the test name
    move $a0, $a2
    li $v0, 4
    syscall

    # print passed or failed.
    beq $t2, $a1, passed
    la $a0, failf
    li $v0, 4
    syscall
    j $ra
passed:
    la $a0, passf
    li $v0, 4
    syscall
    j $ra

build:
    addi $sp,$sp, -28
    sw $ra , 0($sp)
    sw $t0,  4($sp)
    sw $t1,  8($sp)
    sw $t2,  12($sp)
    sw $t3,  16($sp)
    sw $t4,  20($sp)
    sw $t5,  24($sp)


    li    $a0, 16         # $a0 = 16
    li    $v0, 9         # $v0 = 9 requests space from memory / malloc
    syscall
    move  $s0, $v0      ##  Put the address of root in register s0

    lw $t1, 0($s2)      # put the first element of list in register t1
    sw $t1, 0($s0)      # Assign the first element of the list to the value of root.
    sw $zero, 4($s0)    # initialize the left child address of the root with 0
    sw $zero, 8($s0)    # initialize the right child address of the root with 0
    sw $zero, 12($s0)   # initialize the parent address of the root with 0


  ##### root node created
    li $t5, 1              # this is i
    j loop_for_insert




loop_for_insert:
      sll $t6, $t5, 2            # shift i
      add $t4, $s2, $t6
      lw $a0, 0($t4)             # a0 = list[i]
      slti $t7 , $a0, -9998
      bne $t7, $zero return_main  # if a0 > -9998  it means we inserted all the elements in the list. we can exit from the function
      jal insert
      addi $t5,$t5,1             # i++
      j loop_for_insert



insert:
  addi $sp,$sp, -8
  sw $ra , 0($sp)
  sw $a0, 4($sp)

  move    $t0, $a0      #t0 = 4
  li    $a0, 16         # $a0 = 16
  li    $v0, 9         # $v0 = 9 requests space from memory / malloc
  syscall
  move  $s1, $v0      # put the address of the node to be inserted in s1


  sw $t0, 0($s1)       ## assign the value of the node to be inserted
  sw $zero, 4($s1)     ## initialize the left child address of the node to be inserted with 0
  sw $zero, 8($s1)     ## initialize the right child address of the node to be inserted with 0

  move $a0, $s1        # put the node to be inserted address in a0 to use it as parameter for set_left or set_right
  move $a1, $s0        # put the root address in a1 to use it as parameter for set_left or set_right

  lw $t3 ,0($s0)       # t3 = value of root
  lw $t2 ,0($s1)       # t2 = value of to be inserted
  slt $t1, $t3, $t2
  beq $t1, $zero set_left   # if   t3 > t2 set left
  j set_right  # else set set_right


set_left:

    lw $t0, 4($a1)   # t0 = value of root
    move $t2, $a1    # t2 = address of root

    lw $a1, 4($a1)   # a1 = value of root   --- to use it as parameter
    bne $t0,$zero check  ## if there is left child go check
    sw $a0, 4($t2)       ## if there is not left child update the left child address of root
    sw $t2, 12($a0)      ## set parent address

    move $a1, $t2
    j return_here        # we inserted the node so we can go back to insert another.



set_right: ## right version of the set_left function.


    lw $t0, 8($a1)
    move $t1, $a1

    lw $a1, 8($a1)
    bne $t0,$zero check
    sw $a0, 8($t1)
    sw $t1, 12($a0)

    move $a1, $t1
    j return_here

check:                      ## if root has left child or right child we must recursively compare our values to find correct position.
                            ## this function helps to do this.

    lw $t0 ,0($a0)    #t0 = value of to be inserted
    lw $t1 ,0($a1)    #t1 = value of root
    slt $t2, $t0, $t1                                 #
    beq $t2, $zero set_right                          # if statement
    bne $t2, $zero set_left                           #


return_main:

      lw $ra , 0($sp)
      lw $t0,  4($sp)
      lw $t1,  8($sp)                     # exit the build function
      lw $t2,  12($sp)
      lw $t3,  16($sp)
      lw $t4,  20($sp)
      lw $t5,  24($sp)
      addi $sp,$sp, 28

      jr $ra    # ra of build


return_here:

  lw $ra , 0($sp)
  lw $a0, 4($sp)                        # exit the insert function
  addi $sp,$sp, 8

  move $v0, $s1
  jr $ra   # ra of insert





find:
  addi $sp, $sp, -20

  sw $ra , 16($sp)
  sw $t3, 12($sp)
  sw $t2, 8($sp)
  sw $t1, 4($sp)
  sw $t0, 0($sp)



  lw $t0 ,0($a1) ## root value
  lw $t2 ,4($a1) ## address of left of root
  lw $t3 , 8($a1) ## address of right of toor



  li $v0, 0
  move $v1, $a1
  beq $a0, $t0 exit_find
  bne $zero, $t2 ELSE
  bne $zero, $t3 ELSE

  li $v0, 1


  j exit_nfind


ELSE:


    slt $t1, $a0, $t0
    move $a1, $t3   #go right
    beq $t1, $zero check_right ## if value > root value
    move $a1, $t2  #go left
    bne $t1, $zero check_left ## if value < root value

check_right:
  li $v0, 1
  beq $a1,$zero exit_nfind
  j find

check_left:
  li $v0, 1
  beq $a1,$zero exit_nfind
  j find


exit_find:
  lw $ra , 16($sp)
  lw $t3, 12($sp)
  lw $t2, 8($sp)
  lw $t1, 4($sp)
  lw $t0, 0($sp)
  addi $sp, $sp, 20



  jr $ra


exit_nfind:
  lw $ra , 16($sp)
  lw $t3, 12($sp)
  lw $t2, 8($sp)
  lw $t1, 4($sp)
  lw $t0, 0($sp)
  addi $sp, $sp, 20


  jr $ra

print:

      addi $sp, $sp, -4
      sw $ra, 0($sp)


      la $t0, queueStart # start address of queue
      addi $t1, $t0, 4   ## end address of queue

      jal enqueue  # enqueue the root

      j loop_for_print_new_line

loop_for_print_new_line:
   subu $s7,$t1,$t0     ## s7= difference between start and end addresses
   li $t7,4             ## t7 = 4  is the addres difference between start address and end address if there is no element in queue.
   j loop_for_print_value

loop_for_print_value:


  lw $a0, 4($t0)      # a0 = address of node
  lw $a0, 0($a0)      # a0 = value of node
  li $v0, 1           # print node
  syscall


  addi $t6, $t0, 8
  beq $t6, $t1 , continue     # if there is 1 element in the queue continue


  lw $t8,4($t0)
  lw $a0,12($t8)            #  print hyphen if the parents of the first two elements in queue are the same
  lw $t9,8($t0)
  lw $a1,12($t9)
  beq $a0, $a1, print_hyphen

  jal print_space

continue:


      jal dequeue

      lw $t3, 4($v0)  # t3 = left child address of the dequeued node
      lw $t4, 8($v0)  # t4 = right child address of the dequeued node
      move $a0, $t3

      bne $t3, $zero, go_to_enqueue_left    # if there is left child of the dequeued node go to enqueue it
      bne $t4, $zero, go_to_enqueue_right   # if there is not left child of the dequeued node but there is right child go to enqueue it


      addi $s7,$s7,-4
      bne $s7, $t7, loop_for_print_value    ## if level is not finished go to loop_for_print_value
      jal print_new_line                    ## if level is finished print newline

      addi $t6, $t0, 4
      bne $t6, $t1 , loop_for_print_new_line   ## if the tree is not completely printed go to loop_for_print_new_line

      j exit    # else exit print

exit:

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra


go_to_enqueue_left:

  jal enqueue

  bne $t4, $zero, go_to_enqueue_right    ## After enqueuing the left, we must also control the right.


  addi $s7,$s7,-4
  bne $s7, $t7, loop_for_print_value                 ## if level is not finished go to loop_for_print_value
  jal print_new_line                                 ## if level is finished print newline

  addi $t6, $t0, 4
  bne $t6, $t1 , loop_for_print_new_line            ## if the tree is not completely printed go to loop_for_print_new_line

  j exit             # else exit print



go_to_enqueue_right:
  move $a0, $t4
  jal enqueue


  addi $s7,$s7,-4
  bne $s7, $t7, loop_for_print_value                         ## if level is not finished go to loop_for_print_value
  jal print_new_line                                           ## if level is finished print newline

  addi $t6, $t0, 4
  bne $t6, $t1 , loop_for_print_new_line                      ## if the tree is not completely printed go to loop_for_print_new_line

  j exit           # else exit print




enqueue:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  move $t5, $t1 # current addres of end pointer
  addi $t1,$t1,4 ## end pointer + 4
  sw $a0, 0($t5) ## put value to t5



  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra

dequeue:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  lw  $v0, 4($t0)   ## load value to return register
  addi $t0, $t0, 4 ## start pointer + 4


  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra


print_new_line:
    addi $sp, $sp,-12
    sw $a0, 0($sp)
    sw $v0, 4($sp)
    sw $ra, 8($sp)

    la $a0, newline
    li $v0, 4
    syscall

    lw $a0, 0($sp)
    lw $v0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp,12

    jr $ra

print_space:
    addi $sp, $sp,-12
    sw $a0, 0($sp)
    sw $v0, 4($sp)
    sw $ra, 8($sp)

    la $a0, space
    li $v0, 4
    syscall

    lw $a0, 0($sp)
    lw $v0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp,12

    jr $ra

print_hyphen_linker:
    addi $sp, $sp,-12
    sw $a0, 0($sp)
    sw $v0, 4($sp)
    sw $ra, 8($sp)

    la $a0, hyphen
    li $v0, 4
    syscall

    lw $a0, 0($sp)
    lw $v0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp,12

    jr $ra

print_hyphen:
    jal print_hyphen_linker
    j continue
