addi $t0, $zero, 1      #check what n is for a triangle number we give (our test case is n=6)
addi $t1, $zero, 2      # n
j loop

add $a0, $t0, $t1      # n

loop:
    addi $v0,$zero,1      #set syscall type to print int
    SYSCALL               #print $a0
addi $v0,$zero,10     #set syscall type to exit 
SYSCALL               #exit

