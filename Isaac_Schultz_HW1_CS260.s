# Homework 1
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab
MAX = 32		# Loop end point

# System services
PRINT_INT_SERV  = 1
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .data  
inputMsg:		.asciiz "Enter an integer: "
badInputMsg:	.asciiz "Input value too small or too large!\n"
endMsg:			.asciiz "Number of set bits: "

        .text        
main:

	li $t0, 0			# Loop control variable	
	li $t1, 0			# The total number of flipped bits. Starting at 0 because the loop adds $t1 to itself.
	
	# $t2 will be the user number input
	# $t3 will be 0 or 1 depending on if the bit is flipped

	# Prompt for input value
		la $a0, inputMsg
		li $v0, PRINT_STR_SERV
		syscall
	
	# Moves the value the user inputted into #t2
		li $v0, READ_INT_SERV 
		syscall
		move $t2, $v0

Loop:
	
	beq $t0, MAX, End	# End condition for the loop. When the loop counter reaches MAX

	andi $t3, $t2, 1	# Checks if the last bit is 1
	
	add $t1, $t1, $t3	# Increases the count of flipped bits if the last bit was 1
	
	srl $t2, $t2, 1		# Shift the bits of the inputted number right by 1 bit

	addi $t0, $t0, 1	# Increment the loop counter
	b Loop 				# Branch back to Loop:

End:

	# Display end message
		la $a0, endMsg
		li $v0, PRINT_STR_SERV
		syscall

	# Display number of flipped bits
		li $v0, PRINT_INT_SERV
		move $a0, $t1
		syscall

	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main
  

        



