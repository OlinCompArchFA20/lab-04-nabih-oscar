addi $a0, $zero, 6      #check what n is for a triangle number we give (our test case is n=6)
addi $t0, $zero, 0      # n
addi $t1, $zero, 0	# Triangle Number for the given n

# Given a triangle number in a0, this program finds the n base value for that triangle number (n) such that if a triangle is made with n base

loop:
    add $t1,$t0,$t1       # Add the next n to get the new triangle number
    beq $t1,$a0,breakloop #if (n==N) go to breakloop;
    addi $t0,$t0,1        #n++
    j loop                #restart loop
    
breakloop:
    add $a0,$zero,$t0     #return the answer
    addi $v0,$zero,1      #set syscall type to print int
    SYSCALL               #print $a0
    addi $v0,$zero,10     #set syscall type to exit 
    SYSCALL               #exit
