# Homework 3
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab

# System services
PRINT_INT_SERV  = 1
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .data  
Triangle:						.float 2, 6, 2
NotTrianglePrompt:				.asciiz "Not a triangle.\n"
TriangleAreaPrompt:				.asciiz "Triangle area: "

        .text        
main:

	l.s $f0, 0(Triangle)
	l.s $f1, 4(Triangle)
	l.s $f2, 8(Triangle)

	# Preparing the stack for the calls

	addi $sp, $sp, -12					# Allocating 12 bytes on the stack

		sw $f0, 0($sp)
		sw $f1, 4($sp)
		sw $f2, 8($sp)

	jal semiPerimeter					# Calls the DotProduct function

		# Preparing arguments for DisplayOutput function.
			move $a0, $v0				# Stores whether the arrays are equal size $a0
			move $a1, $v1				# Stores the dot product in $a1
			la $a2, V1AndV2Result		# Loads the address of the prompt to output in $a2
			jal DisplayOutput			# Calls DisplayOutput function


	# Preparing the stack for the next function call.
		addi $sp, $sp, 16				# Pops 4 bytes off the stack


	# Calling the second DotProduct function and dealing with output.

		jal DotProduct					# Calls the DotProduct function

		# Preparing arguments for DisplayOutput function.
			move $a0, $v0				# Stores whether the arrays are equal size $a0
			move $a1, $v1				# Stores the dot product in $a1
			la $a2, V1AndV3Result		# Loads the address of the prompt to output in $a2
			jal DisplayOutput			# Calls DisplayOutput function


	# Preparing the stack for the next function call.
		addi $sp, $sp, 16				# Pops 4 bytes off the stack


	# Calling the third DotProduct function and dealing with output.

		jal DotProduct					# Calls the DotProduct function

		# Preparing arguments for DisplayOutput function.
			move $a0, $v0				# Stores whether the arrays are equal size $a0
			move $a1, $v1				# Stores the dot product in $a1
			la $a2, V2AndV3Result		# Loads the address of the prompt to output in $a2
			jal DisplayOutput			# Calls DisplayOutput function

	# Resotring the stack back to the the address
		addi $sp, $sp, 16				# Pops 4 bytes off the stack

	# Display NewLine
		la $a0, NL
		li $v0, PRINT_CHAR_SERV
		syscall	
		
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main




# Function that calculates the dot Product of two arrays.
# Arguments:	Address of the first array.					(at $sp + 0)	or	0($sp)
#				Number of elements in first array.			(at $sp + 4)	or	4($sp)
#				Address of the second array.				(at $sp + 8)	or	8($sp)
#				Number of elements in second array.			(at $sp + 12)	or	12($sp)
#
# Returns:		boolean if arrays have the same size:		in $v0
#					returns 0 if the arrays are not equal
#					returns 1 if the arrays are equal
#				The Dot Product of the two arrays.			in $v1
#
# Uses  registers: $t0-$t4
semiPerimeter:

	#addi $sp, $sp, -16			# Set the stack pointer back to the start of the arguments for the subroutine.
	
	lw $t0, 4($sp)				# Initialize $t0 to the number of elements in the first array.
								# Number of elements in the first array is stored in 4($sp).
								
	lw $t1, 12($sp)				# Initialize $t1 to the number of elements in the second array.
								# Number of elements in the second array is stored in 12($sp).

	sub $v0, $t0, $t1			# Subtract the number of elements and store the result in $v0.
	add $v0, $v0, 1				# Add 1 to the difference in the number of elements and store the result in $v0.
								# After this $v0 will be 1 if the arrays are the same size.
								# $v0 will be non-zero if the arrays are not the same size.
							
	beq $v0, 1, Continue		# If arrays have the same size, move on in the subroutine.
	
	# If arrays are not the same size:
		lw $v0, 0				# Set $v0 to 0 because the arrays are not the same size.
		b End					# End the subroutine.

Continue:

	li $t0, 0 					# Initialize the loop counter
	
	lw $t1, 0($sp)				# Initialize the address of the first array.

	lw $t2, 4($sp)				# Initialize the size of both arrays.
								# 	We know both arrays are equal because we branched here from the conditional
								#	statement checking if they were the same size.

	lw $t3, 8($sp)				# Initialize the address of the second array.
	
	li $v1, 0					# Initialize the Dot Product Total
	
	# $t4 will be the temporary product of two elements in each array
	
Loop:
	
	beq $t0, $t2, End			# End condition for the loop.
								#	When the loop counter equals the number of elements in the arrays

	lw $t5, 0($t1)				# Copying the dereferenced values of the element of the arrays.
	lw $t6, 0($t3)
		
	mul $t4, $t5, $t6			# multiplies the current element of each array.
	
	add $v1, $v1, $t4			# Increases the total by the product of the current two elements.
	addi $t1, $t1, 4			# Increment the first array pointer by 1 word.
	addi $t3, $t3, 4			# Increment the second array pointer by 1 word.

	addi $t0, $t0, 1			# Increment the loop counter
	b Loop 						# Branch back to Loop:
		
End:
	
	#addi $sp, $sp, 16			# Resetting the stack back to what it was at the beginning
	jr $ra						# Jump back to the return address
.end DotProduct




# Function that informs the user about a Dot Product of two vectors.
# Arguments:	$a0		Boolean value if the vectors are the same size.
#							0 Means vectors are not same size.
#							1 Means vectors are the same size.
#				$a1		Integer result of the dot product between two vectors.
#							will be 0 if they are perpendicular
#				$a2		Address of the prompt to the user.
#
# Returns:		N/A
# Uses  registers: $t0
DisplayOutput:

	move $t0, $a0								# Saves the boolean of if the vectors are equal to $t0
	
	# We dont need to save $a1 or $a2 because no part of the subroutine makes changes to them.

	beq $t0, 1, DisplayOutputContinue		# If Vectors are the same size, branch to DisplayOutputContinue
	
	# If Vectors are not the same size
		# Tells the user that the arrays are not the same size
			la $a0, ArrayNotEqual
			li $v0, PRINT_STR_SERV
			syscall		
		b EndDisplayOutput					# Ends the subroutine			
	
DisplayOutputContinue:
	
	# Print the start of the start of the result message
		move $a0, $a2
		li $v0, PRINT_STR_SERV
		syscall
	
	beq $a1, 0, VectorPerpendidular		# If the dot product is not 0, branch to VectorPerpendidular
	
	# if the vectors are not perpendicular, print that they are not perpendicular
		la $a0, NotPerpendicular
		li $v0, PRINT_STR_SERV
		syscall

	b EndDisplayOutput 						# Ends the subroutine

VectorPerpendidular:

	# if the vectors are perpendicular, print that they are perpendicular
		la $a0, Perpendicular
		li $v0, PRINT_STR_SERV
		syscall

EndDisplayOutput:
	
	jr $ra 				# Jump back to main program

.end DisplayOutput