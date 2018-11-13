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
Triangle:						.float 2.0, 6.0, 2.0
NotTrianglePrompt:				.asciiz "Not a triangle.\n"
TriangleAreaPrompt:				.asciiz "Triangle area: "

        .text        
main:
	la $t0, Triangle
	l.s $f0, 0($t0)
	l.s $f1, 4($t0)
	l.s $f2, 8($t0)
	
	# Preparing the stack for the calls

	addi $sp, $sp, -12					# Allocating 12 bytes on the stack

		s.s $f0, 0($sp)
		s.s $f1, 4($sp)
		s.s $f2, 8($sp)

	jal semiPerimeter					# Calls the semiPerimeter function
										#	$f0 is now the semiPerimeter.
	addi $sp, $sp, 12					# Pops 12 bytes off the stack
	
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main




# Function that calculates the dot Product of two arrays.
# Arguments:	Length of side a					(at $sp + 0)	or	0($sp)
#				Length of side b					(at $sp + 4)	or	4($sp)
#				Length of side c					(at $sp + 8)	or	8($sp)
#
# Returns:		Semiperimiter of the triangle		in $f0
#					returns a float representing half of the perimeter of the triangle.
#
# Uses  registers: $f0, $f1
semiPerimeter:
	
	l.s $f0, 0($sp)				
	l.s $f1, 4($sp)
	add.s $f0, $f0, $f1
	l.s $f1 , 8($sp)
	add.s $f0, $f0, $f1
		
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