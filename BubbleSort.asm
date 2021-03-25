.data
TEXT_BUFFER:	.asciiz "CADBCAAEZBAECCBA"
LENGTH:		.word	16	

##############################################################
.text

MainLoop:	
		la $s1 TEXT_BUFFER
		la $s0 LENGTH	
		
		jal sort
		
Print:		li $v0 4	# print string
		move $a0 $s1
		syscall
		
exit:		li $v0 10 	# exit
		syscall


##############################################################
# s0 length 
# s1 address to first value
sort:
	addi $sp $sp -12
	sw $ra ($sp)  # save return address
	sw $s0,4($sp)  # save $s0 
 	sw $s1,8($sp)  # save $s1
	
	li $t7, 0 		 	# swapped. 0 = true, 1 = false 
	swappedLoop:   
	lb $t6, ($s0)	 		# move length to t6 so it can be decremented
	subi $t6, $t6, 1 		# Decrement offset (starting with length) by 1
	bgtz $t7, bubbleExit 		# if swapped is false, exit
	li $t7, 1 			# set swapped to false
	loopCount4:
	beq $t6, $zero, swappedLoop	# if offset = 0, exit to while loop
	subi $t5, $t6, 1 		# t5 is t6 - 1
	move $t0, $t6 			# get offset = current value
	move $t1, $t5	 		# get (offset - 1) = previous value
	add $t2, $t0, $s1 		# add offset to s1 address to get current address
	add $t3, $t1, $s1 		# add (offset-1) to s1 address to get previous address
	lb $t4, ($t2)			# load current value(offset) into t4 
	lb $t5, ($t3)			# load previous value(offset-1) into t5 
	blt $t4, $t5, swapPositions 	# branch if current value is less than previous value
	subi $t6, $t6, 1 		# decrement offset
	j loopCount4 			# return for loop

swapPositions: 
	sb  $t5, ($t2) 			# store the previous value into the address of t2 
	sb  $t4, ($t3)			# store the current value into the address of t3
	subi $t6, $t6, 1 		# decrement offset
	li $t7, 0 			# set swapped to true
	j loopCount4			# return to for loop

bubbleExit: 
	lw $s0,4($sp)  # load $s0
	lw $s1,8($sp)  # load $s1
	lw $ra ($sp)   # load return address
	addi $sp $sp 12
	jr $ra
	
