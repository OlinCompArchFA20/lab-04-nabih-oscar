addi $t0, $zero, 1      #check what n is for a triangle number we give (our test case is n=6)
addi $t1, $zero, 1     # n
beq $t1,$t0,loop #if (n==N) go to breakloop;

add $a0, $t0, $t1      # n
add $a0, $a0, $t1      # n
add $a0, $a0, $t1      # n

loop:
    addi $v0,$zero,1      #set syscall type to print int
    SYSCALL               #print $a0
addi $v0,$zero,10     #set syscall type to exit 
SYSCALL               #exit

