# Homework 5
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab

# System services
PRINT_INT_SERV  = 1
PRINT_FLT = 2
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .data
Input_str:      			.asciiz "Enter the column number: "
Summary_str: 				.asciiz "Sum of elements in that column: "
Invalid_Column_Number:		.asciiz "Invalid column number. Try again.\n"

		.align 2 # Align the array on a 4-byte boundary  
Array:
Row0:  				.word  1,	6,  8,	10,	12,	2
Row1:  				.word 14,	2,	18,	20,	24,	3
Row2:  				.word 30,	32,	3,	10, 5,	4
Row3: 				.word  1,	2,	3,  4,  5,	5
Row4:  				.word 10,	15,	20, 5,  6,	6

        .text        
main:

Start:

	la $t0, Row0			# Loading addresses the first two rows of the array.
	la $t1, Row1	

	sub $t2, $t1, $t0		# Subtracts the address of Row1 from Row0.
	srl $t2, $t2, 2			# Divides the difference by 4.
							# $t2 is now the number of columns. 
							#	This assumes all rows are the same size.
							
	# Prompt for input value
		la $a0, Input_str
		li $v0, PRINT_STR_SERV
		syscall
	
	# Moves the value the user inputted into #t3
		li $v0, READ_INT_SERV 
		syscall
		move $t3, $v0
	
	bgt $t3, $t2, InvalidInput		# If user input is larger than the number of columns.
	blt $t3, $Zero, InvalidInput	# If the user input is less than 0
									# 	Tells the user their input is invalid.
	# If input is valid:
	
	sll $t3, $t3, 2					# Multiplies the column number by 4 to get its position in bytes.

	# Setting up arguments for function call.
	add $a0, $t0, $t3				# Adds the column position to the address of row0.
									#	Saves the result as one of the arguments for ColumnSum function.
	move $a1, $t2					# Saving row size for ColumnSum function.

	jal ColumnSum					# Calls ColumnSum.
									#	$v0 is now the sum of the elements in that column
	
InvalidInput:  

	# Display invalid message
		la $a0, Invalid_Column_Number
		li $v0, PRINT_STR_SERV
		syscall	
	b Start			# Go back to the start of the program.
	
EndProgram:	
	
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main

# Function that calculates the sum of all the elements in a 2 dimensional array with 5 rows
# Arguments:	$a0:	Address of the first element
#				$a1:	Number of elements in each row
# Returns:		$v0:	The sum of the elements in the given column
# Uses  registers: $t0-$t1
ColumnSum:

	li $t0, 0 			# Initialize the loop counter
	sll $a1, $a1, 2		# Multiply the number of elements in each row to get the size in bytes.
	li $v0, 0			# Initialize the sumTotal
	
	# $t1 will be the temporary product of two elements in each array
	
	Loop:
	
		beq $t0, 5, End			# End condition for the loop. When the loop counter reaches 5.
								# 5 is the number of rows in the arrays.

		lw $t2, 0($a0)			# Reads the element at the current address			
	
		add $v0, $v0, $t1		# Increases the total by the current element.
		
		add $a0, $a0, $a1		# Increment the $a0 pointer by 1 row.		
				
		addi $t0, $t0, 1		# Increment the loop counter
		b Loop 					# Branch back to Loop:
		
	End:
		jr $ra				# Jump back to the return address
.end ColumnSum