# Homework 2
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
Prices:				.word 52, 112, 36, 95, 28, 16, 64	
Sales:				.word 220, 50, 65, 23, 152, 204, 23
ArrayNotEqual:		.asciiz "Arrays do not have the same number of elements"
TotalSalesPrompt:	.asciiz "Total Sales: "

        .text        
main:

	la $t0, Prices			# Loading addresses of our data into registers $t0-$t2
	la $t1, Sales
	la $t2, ArrayNotEqual

	sub $t3, $t1, $t0		# Subtracts the address of Sales from the address of Prices.
	srl $t3, $t3, 2			# Divides $t3 by 4 by shifting bits to the right by 2
	
	sub $t4, $t2, $t1		# Subtracts the address of ArrayNotEqual from the address of Sales.
	srl $t4, $t4, 2			# Divides $t4 by 4 by shifting bits to the right by 2
	
	bne $t3, $t4, PromptArrayNotEqual	# If Arrays are not the same size, ($t3 != #t4)
	
		la $a0, Prices 	# Setting up arguments for DotProduct subroutine
		la $a1, Sales
		move $a2, $t3	# The number of elements in the array
		jal DotProduct	# Calls the DotProduct function
		move $t0, $v0	# Stores the ootput of the function in $t0
		
		# Display message
			la $a0, TotalSalesPrompt
			li $v0, PRINT_STR_SERV
			syscall
			
		# Display Dot Product Total
			li $v0, PRINT_INT_SERV
			move $a0, $t0
			syscall
			
		# Display NewLine
			la $a0, NL
			li $v0, PRINT_CHAR_SERV
			syscall	
	
	b MainContinue # If arrays are the same size continue.

PromptArrayNotEqual:

	# Display message
		la $a0, ArrayNotEqual
		li $v0, PRINT_STR_SERV
		syscall
		
	# Display NewLine
		la $a0, NL
		li $v0, PRINT_CHAR_SERV
		syscall	
	
	b MainContinue # Branch back to main program

MainContinue:	
	
	# Display number of elements in Prices
		li $v0, PRINT_INT_SERV
		move $a0, $t3
		syscall		
		
	# Display NewLine
		li $v0, PRINT_CHAR_SERV
		la $a0, NL		
		syscall	
		
	# Display number of elements in Sales
		li $v0, PRINT_INT_SERV
		move $a0, $t4
		syscall	

	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main
  
  
  
# Function that calculates the dot Product of two arrays.
# Arguments:	$a0:	Address of the first array.
#				$a1:	Address of the second array.
#				$a2:	Number of elements in both arrays.
# Returns:		$v0:	The Dot Product of the two arrays.
# Uses  registers: $t0-$t2
DotProduct:

	li $t0, 0 			# Initialize the loop counter
	li $t1, 0			# Initialize the Dot Product Total
	
	# $t2 will be the temporary product of two elements in each array
	
	Loop:
	
		beq $t0, $a2, End			# End condition for the loop. When the loop counter reaches $a2.
									# $a2 is the number of elements in the arrays.

		lw $t5, 0($a0)
		lw $t6, 0($a1)
		
		mul $t2, $t5, $t6		# multiplies the current element of each array.
	
		add $t1, $t1, $t2			# Increases the total by the product of the current two elements.
		add $a0, $a0, 4				# Increment the $a0 pointer by 1 word.
		add $a1, $a1, 4				# Increment the $a0 pointer by 1 word.
				
		addi $t0, $t0, 1			# Increment the loop counter
		b Loop 						# Branch back to Loop:
		
	End:
		
		move $v0, $t1		# Moves the Dot Product into $v0	
		
		jr $ra				# Jump back to the return address
.end DotProduct
	
        



