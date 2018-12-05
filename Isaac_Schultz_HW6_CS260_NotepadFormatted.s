# Homework 6
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab
SPACE = ' '		# Space
LISTSIZE = 10
LISTLOWESTINDEX = 0

# System services
PRINT_INT_SERV  = 1
PRINT_FLT = 2
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .text        
main:
							
	# Prompt for input value
	la $a0, inputMsg
	li $v0, PRINT_STR_SERV
	syscall
	
	# Moves the value the user inputted into #a1
	li $v0, READ_INT_SERV 
	syscall
	move $a1, $v0
	
	bgt $a1, LISTSIZE, InvalidInput				# If user input is larger than the number of nodes.
	blt $a1, LISTLOWESTINDEX, InvalidInput			# Or the user input is less than the lowest index
								# 	Tell the user their input is invalid.
	# If input is valid:

	la $a0, head						# Setting up arguments for function call.
	
	jal FindNumber						# Runs FindNumber function
								# $a2 is now to address of the string in the node that was found
	
	# Write the string found in the node
	move $a0, $a2
	li $v0, PRINT_STR_SERV
	syscall
		
	# Write message that shows up before the list
	la $a0, Full_List
	li $v0, PRINT_STR_SERV
	syscall
	
	la $a0, head						# loading function arguments
		
	jal PrintList						# Prints the whole list
		
	b EndProgram						# End the program.
	
InvalidInput:  

	# Display invalid message
	la $a0, Invalid_Number
	li $v0, PRINT_STR_SERV
	syscall	
	b main							# Go back to the start of the program.
	
EndProgram:	
	
	# Display end message
	la $a0, endMsg
	li $v0, PRINT_STR_SERV
	syscall
	
	# End program
	li $v0, TERMINATE_SERV
	syscall
		
.end main





# Function that Prints the contents of a linkedList
# Arguments:	$a0:	Address of dictionary head.
# Returns:	N/A
# Uses  registers: $t0-$t1
PrintList:
	
	move $t0, $a0				# Saves the address of dictionary head
	
	Loop:
	
		beq $t0, 0, End			# End condition for the loop. When the current address is null.

		lw $t1, 4($t0)			# Reads the address of the next node.
		addi $a0, $t0, 8		# Load the address of the string in this node in $a0
		
		# Display the string.
		li $v0, PRINT_STR_SERV
		syscall	
		
		# Display a tab
		la $a0, SPACE
		li $v0, PRINT_CHAR_SERV
		syscall	
		
		move $t0, $t1			# moves on to the next node.
		
		b Loop 				# Branch back to Loop:
		
	End:
	
		jr $ra				# Jump back to the return address
		
.end PrintList





# Function that Searches through a linked list for a numeral value.
# Arguments:	$a0:	Address of dictionary head.
#		$a1:	integer value to search through the list for.
# Returns:	$a2:	The address of the italian word.
# Uses  registers: $t0-$t1
FindNumber:
	
	FindLoop:

		lw $t0, 0($a0)			# Reads the numeral at this node.
		lw $t1, 4($a0)			# Reads the address of the next node
		
		beq $t0, $a1, Found		# When it hits the value that is being searched for.
		
		move $a0, $t1			# moves on to the next node.
		
		beq $t1, 0, FindEnd		# End condition for the loop. When the address for the next node is 0.
				
		b FindLoop 			# Branch back to FindLoop:
		
	Found:
		
		addi $a2, $a0, 8		# Load the address of the italian word in $a2	
		
	FindEnd:
	
		jr $ra				# Jump back to the return address
		
.end FindNumber



        .data
		
Invalid_Number:			.asciiz "Invalid number. Try again.\n"
Full_List:			.asciiz "\nFull List: "
inputMsg:			.asciiz "Enter a number in the range of 0 through 10:"
endMsg: 			.asciiz "\nDone!\n"

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

nodeEND:.word -1
	.word NULL
	.asciiz "Fine"