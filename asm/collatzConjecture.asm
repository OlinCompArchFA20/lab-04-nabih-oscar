addi $a0, $zero, 728127      # check what the number of steps is for the given number usign Collatz Conjecture
addi $a1, $zero, 2	 # parameter is 2 because we divide by 2 to check if num is even
addi $a2, $zero, 3	 # parameter is 3 because we multiply by 3 for collatz
addi $t0, $a0, 0     # number
addi $t1, $zero, 1   # steps

loop:
	#check if num is already 1
	#if yes breakloop
	beq $t0,1,breakloop #if (n==1) go to breakloop;
	#if not add step and
	addi $t1, $t1, 1
	#Check if number is even 
    	div $t0, $a1
    	mfhi $t2
    	beq $t2, $zero, even
    	beq $t2, 1, odd
even:
	div $t0, $a1
	mflo $t0
	j loop
odd:
	mult $t0, $a2
	mflo $t0
	addi $t0, $t0, 1
	j loop

breakloop:
    add $a0,$zero,$t1     #return the answer
    addi $v0,$zero,1      #set syscall type to print int
    SYSCALL               #print $a0
    addi $v0,$zero,10     #set syscall type to exit 
    SYSCALL               #exit
