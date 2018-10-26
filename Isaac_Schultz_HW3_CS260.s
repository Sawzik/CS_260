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
Vector1:					.word 2, 6, 2
Vector2:					.word 4, -3, 5
Vector3:					.word 5, 15, 5
ArrayNotEqual:				.asciiz "Vectors are not the same size\n"
V1AndV2Result:				.asciiz "Vector 1 and vector 2 are "
V1AndV3Result:				.asciiz "Vector 1 and vector 3 are "
Perpendicular:				.asciiz "perpendicular\n"
NotPerpendicular:			.asciiz "not perpendicular\n"

        .text        
main:

	la $t0, Vector1				# Loading addresses of our data into registers $t0-$t3
	la $t1, Vector2
	la $t2, Vector3
	la $t3, ArrayNotEqual
	
	sub $t0, $t1, $t0				# Subtracts the address of Vector2 from the address of Vector1.
									# $t0 is now the size of Vector1 in bytes
	srl $t0, $t0, 2					# Divides the size of Vector1 by 4 by shifting bits to the right by 2
									# $t0 is now the size of Vector 1 in words

	sub $t1, $t2, $t1				# Subtracts the address of Vector3 from the address of Vector2.
									# $t1 is now the size of Vector2 in bytes
	srl $t1, $t1, 2					# Divides the size of Vector2 by 4 by shifting bits to the right by 2
									# $t1 is now the size of Vector 2 in words
	
	sub $t2, $t3, $t2				# Subtracts the address of ArrayNotEqual from the address of Vector3.
									# $t2 is now the size of Vector3 in bytes
	srl $t2, $t2, 2					# Divides the size of Vector1 by 4 by shifting bits to the right by 2
									# $t2 is now the size of Vector 1 in words							
	
	# Using the stack to save the values stored in registers that will be used by a subroutine.
	addi $sp, $sp, -8				# Allocating 2 words on the stack
	sw $t1, 0($sp)					# Saves the size of Vector2 on the stack.
	sw $t2, 4($sp)					# Saves the size of Vector3 on the stack.
	
	# Preparing the stack for the DotProduct function call
	addi $sp, $sp, -16				# Allocating 4 words on the stack
	sa Vector1, 0($sp)				# Saving the address of vector1 on the stack.
	sw $t0, 4($sp)					# Saving the size of Vector1 on the stack.
	sa Vector2, 8($sp)				# Saving the address of vector2 on the stack.
	sw $t1, 12($sp)					# Saving the size of Vector2 on the stack.
	
	
	jal DotProduct					# Calls the DotProduct function
	move $t0, $v0					# Stores whether the arrays are equal size $t0
	
	beq $t0, 1, DisplayOutput1		# If Vectors are the same size, branch to DisplayOutput1
	
	# If Vectors are not the same size
		jal PromptArrayNotEqual		# Tells the user that the arrays are not the same size
		b FunctionCall2				# Branches to the next part of the program				
	
DisplayOutput1:
	
	# Print the start of the start of the result
		la $a0, V1AndV2Result
		li $v0, PRINT_STR_SERV
		syscall
	
	bnq $v1, 0, V1NotPerpendidular	# If the dot product is not 0
	
	# if the vectors are perpendicular, print that they are perpendicular
		la $a0, Perpendicular
		li $v0, PRINT_STR_SERV
		syscall

V1NotPerpendidular:

	# if the vectors are not perpendicular, print that they are not perpendicular
		la $a0, NotPerpendicular
		li $v0, PRINT_STR_SERV
		syscall
		
	b FunctionCall2 				# Branches to the next part of the program


MainContinue:		

	# Display NewLine
		la $a0, NL
		li $v0, PRINT_CHAR_SERV
		syscall	
		
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main


PromptArrayNotEqual:

	# Display message
		la $a0, ArrayNotEqual
		li $v0, PRINT_STR_SERV
		syscall
	
	jr $ra 				# Jump back to main program

.end PromptArrayNotEqual

  
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
DotProduct:

	addi $sp, $sp, -16			# Set the stack pointer back to the start of the arguments for the subroutine.
	
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
	
	lw $t1, 4($sp)				# Initialize the size of both arrays.
								# 	We know both arrays are equal because we branched here from the conditional
								#	statement checking if they were the same size.

	lw $t2, 0($sp)				# Initialize the address of the first array.
	lw $t3, 12($sp)				# Initialize the address of the second array.
	
	li $v1, 0					# Initialize the Dot Product Total
	
	# $t4 will be the temporary product of two elements in each array
	
Loop:
	
	beq $t0, $t1, End			# End condition for the loop.
									#	When the loop counter equals the number of elements in the arrays

	lw $t5, 0($t2)				# Copying the dereferenced values of the element of the arrays.
	lw $t6, 0($t3)
		
	mul $t4, $t5, $t6			# multiplies the current element of each array.
	
	add $v1, $v1, $t4			# Increases the total by the product of the current two elements.
	addi $t2, $t2, 4				# Increment the first array pointer by 1 word.
	addi $t3, $t3, 4				# Increment the second array pointer by 1 word.

	addi $t0, $t0, 1			# Increment the loop counter
	b Loop 						# Branch back to Loop:
		
End:
	
	addi $sp, $sp, 16			# Resetting the stack back to what it was at the beginning
	jr $ra						# Jump back to the return address
.end DotProduct
	
        



