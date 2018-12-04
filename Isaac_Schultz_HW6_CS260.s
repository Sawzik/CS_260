# Homework 6
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab
LISTSIZE = 10	

# System services
PRINT_INT_SERV  = 1
PRINT_FLT = 2
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .data
Invalid_Number:		.asciiz "Invalid column number. Try again.\n"

        .text        
main:
							
	# Prompt for input value
	la $a0, Input_str
	li $v0, PRINT_STR_SERV
	syscall
	
	# Moves the value the user inputted into #t3
	li $v0, READ_INT_SERV 
	syscall
	move $a1, $v0
	
	bgt $a1, LISTSIZE, InvalidInput		# If user input is larger than the number of nodes.
	blt $a1, 0, InvalidInput			# Or the user input is less than 0
										# 	Tell the user their input is invalid.
	# If input is valid:

	# Setting up arguments for function call.

	la $a0, head
	
	jal FindNumber						# Runs FindNumber function
										# $a2 is now to address of the string in the node we searched
	
	# Write output message
	move $a0, $a2
	li $v0, PRINT_STR_SERV
	syscall
		
	# Display NewLine
	la $a0, NL
	li $v0, PRINT_CHAR_SERV
	syscall	
		
	jal PrintList						# Prints the whole list
		
	b EndProgram					# End the program.
	
InvalidInput:  

	# Display invalid message
	la $a0, Invalid_Column_Number
	li $v0, PRINT_STR_SERV
	syscall	
	b main							# Go back to the start of the program.
	
EndProgram:	

	# Display NewLine
	la $a0, NL
	li $v0, PRINT_CHAR_SERV
	syscall	
	
	# End program
	li $v0, TERMINATE_SERV
	syscall
		
.end main

# Function that Prints the entire contents of a linkedList
# Arguments:	$a0:	Address of dictionary head.
# Returns:		N/A
# Uses  registers: $t0-$t1
PrintList:
	
	move $t0, $a0				# Saves the address of dictionary head
	
	Loop:

		lw $t1, 4($t0)			# Reads the address of the next node.
		lw $t2, 8($t0)			# loads the address of the string in this node.
		
		beq $t1, NULL, End		# End condition for the loop. When the loop counter is larger than the list size.
		
		# Display the string.
		move $a0, $t0
		li $v0, PRINT_STR_SERV
		syscall	
		
		move $a0, $t0			# moves on to the next node.
		
		b Loop 					# Branch back to Loop:
		
	End:
	
		jr $ra					# Jump back to the return address
		
.end PrintList

# Function that Searches through the linked list for a numeral value.
# Arguments:	$a0:	Address of dictionary head.
#				$a1:	integer value to search through the list for.
# Returns:		$a2:	The address of the italian word.
# Uses  registers: $t0-$t1
FindNumber:
	
	Loop:

		lw $t0, 0($a0)			# Reads the numeral at this node.
		lw $t1, 4($a0)			# Reads the address of the next node
		
		beq $t0, $a1, Found		# When it hits the value that is being searched for.
		
		move $a0, $t1			# moves on to the next node.
		
		beq $t0, NULL, End		# End condition for the loop. When the loop counter is larger than the list size.
				
		b Loop 					# Branch back to Loop:
		
	Found:
	
		lw $a2, 8($a0)			# Load the address of the italian word in $a2
		
	End:
	
		jr $ra					# Jump back to the return address
		
.end FindNumber



        .data
inputMsg:			.asciiz "Enter a number in the range of 0 through 10..."
endMsg: 			.asciiz "Done!\n"

	.align 2		# Align what follows in a 4-byte boundary

head:
node0:	.word 0
		.word node1
		.asciiz "zero"

node1:  .word 1
        .word node2
		.asciiz "uno"


node2:  .word 2
        .word node3
		.asciiz "due"
         

node3:  .word 3
        .word node4
		.asciiz "tre"
         

node4:  .word 4
		.word node5
		.asciiz "quattro"
         

node5:  .word 5
        .word node6
		.asciiz "cinque"
         

node6:  .word 6
        .word node7
		.asciiz "sei"
         

node7:  .word 7
        .word node8
		.asciiz "sette"
         

node8:  .word 8
        .word node9
		.asciiz "otto"
         

node9:  .word 9
        .word node10
		.asciiz "nove"
         

node10: .word 10
		.word nodeEND
		.asciiz "dieci"

nodeEND:	.word -1
			.word NULL
			.asciiz "Fine"