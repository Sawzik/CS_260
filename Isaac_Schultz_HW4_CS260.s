# Homework 3
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
Two:							.float 2.0
Triangle:						.float 10.0, 10.0, 10.0
NotTrianglePrompt:				.asciiz "Not a triangle.\n"
TriangleAreaPrompt:				.asciiz "Triangle area: "

        .text        
main:
	la $t0, Triangle
	l.s $f0, 0($t0)
	l.s $f1, 4($t0)
	l.s $f2, 8($t0)
	
	# Preparing the stack

	addi $sp, $sp, -12					# Allocating 12 bytes on the stack

		s.s $f0, 0($sp)
		s.s $f1, 4($sp)
		s.s $f2, 8($sp)

	jal semiPerimeter					# Calls the semiPerimeter function
										#	$f0 is now the semiPerimeter.
										
	addi $sp, $sp, -4					# Allocating 4 more bytes on the stack
	
	la $t0, Triangle
	l.s $f1, 0($t0)
	l.s $f2, 4($t0)
	l.s $f3, 8($t0)
	
	# Preparing the stack

		s.s $f1, 0($sp)					# Saves the sidelengths to the stack
		s.s $f2, 4($sp)
		s.s $f3, 8($sp)
		s.s $f0, 12($sp)				# Saves the semiperimeter to the stack
		
	jal isTriangle						# Calls the isTriangle function
										#	$v0 is now a bool representing the triangle.
										
	beq $v0, 0, ReturnNotTriangle		# If the sides are not capable of being a triangle.
	
	# else
	
	jal triangleArea					# Calls the triangleArea function.
	
	# Display traingle area message
		la $a0, TriangleAreaPrompt
		li $v0, PRINT_STR_SERV
		syscall	
		
		mov.s $f12, $f0
		li $v0, PRINT_FLT
		syscall
		
		b EndProgram
	
ReturnNotTriangle:

	# Display not a triangle message
		la $a0, NotTrianglePrompt
		li $v0, PRINT_STR_SERV
		syscall	
	
EndProgram:	
	
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main




# Function that Semiperimiter of a triangle.
# Arguments:	Length of side a					(at $sp + 0)	or	0($sp)
#				Length of side b					(at $sp + 4)	or	4($sp)
#				Length of side c					(at $sp + 8)	or	8($sp)
#
# Returns:		Semiperimiter of the triangle		in $f0
#					returns a float representing half of the perimeter of the triangle.
#
# Uses  registers: $f0, $f1
semiPerimeter:
	
	l.s $f0, 0($sp)				# loads first 2 sidelengths from the stack
	l.s $f1, 4($sp)
	add.s $f0, $f0, $f1			# adds them and stors in $f0
	l.s $f1 , 8($sp)			# Loads the last sidelength from the stack
	add.s $f0, $f0, $f1			# Adds the last sidelength to the other two
	l.s $f1, Two				# Loads 2 as a float into $f1
	div.s $f0, $f0, $f1
	jr $ra						# Jump back to the return address
	
.end semiPerimeter




# Function that determines whether 3 sides can form a triangle.
# Arguments:	Length of side a					(at $sp + 0)	or	0($sp)
#				Length of side b					(at $sp + 4)	or	4($sp)
#				Length of side c					(at $sp + 8)	or	8($sp)
#				SemiPerimiter						(at $ap + 12)	or	12($sp)
#
# Returns:		bool if the sidelengths are a triangle in $v0
#					returns 0 if it is not a triangle.
#					returns 1 if it is a triangle.
#
# Uses  registers: $f0, $f1, $t0
isTriangle:
	
	li $t0, 0					# Initializing loop counter to 0
	move $t1, $sp					# Saves the address of the stack pointer so that it can be iterated on.
	l.s $f0, 12($sp)			# ssaves the semiPerimeter in $f0
	
Loop:
	
	beq $t0, 3, WasATriangle			# End condition for the loop. When the loop counter reaches 3
										#	Should only happen if all the sides were less than the semiperimiter

	l.s $f1, ($t1)						# Load the float on the bottom of the stack
	c.le.s $f0, $f1			 			# End the loop if one of the sides is >= semiperimiter
	bc1t WasNotTriangle
				
	addi $t1, $t1, 4					# Up the stack counter to look 
	addi $t0, $t0, 1					# Increment the loop counter
	b Loop 								# Branch back to Loop:
		
WasATriangle:
	li $v0, 1
	b End
	
WasNotTriangle:
	li $v0, 0
	b End
	
End:
	jr $ra								# Jump back to the return address
	
.end isTriangle




# Function that determines the area of a triangle using the length of each side and the semiPerimeter.
# Arguments:	Length of side a					(at $sp + 0)	or	0($sp)
#				Length of side b					(at $sp + 4)	or	4($sp)
#				Length of side c					(at $sp + 8)	or	8($sp)
#				SemiPerimiter						(at $ap + 12)	or	12($sp)
#
# Returns:		Area of the triangle as a float in $f0
#
# Uses  registers: $f0-$f3
triangleArea:
	
	l.s $f0, 12($sp)			# ssaves the semiPerimeter in $f0
	
	l.s $f1, 0($sp)				# Load the float on the bottom of the stack
	sub.s $f1, $f0, $f1			# Subtract the sidelength from the semiperimeter and save in $f1
	
	l.s $f2, 4($sp)				# Load the next sidelength off the stack
	sub.s $f2, $f0, $f2			# Subtract the sidelength from the semiperimeter and save in $f2
	
	l.s $f3, 4($sp)				# Load the last sidelength off the stack
	sub.s $f3, $f0, $f3			# Subtract the sidelength from the semiperimeter and save in $f3	
	
	mul.s $f0, $f0, $f1			# $f0 = (semiperimiter) * (semiperimeter - side 1)
	mul.s $f1, $f2, $f3			# $f1 = (semiperimeter - side 2) * (semiPerimeter - side 3)
	
	mul.s $f0, $f0, $f1			# $f0 = (semiperimiter) * (semiperimeter - side 1)
								#		* (semiperimeter - side 2) * (semiPerimeter - side 3)
								
	sqrt.s $f0, $f0				# Takes the square root of the calculated value and stores it in $f0
		
	jr $ra								# Jump back to the return address
	
.end triangleArea