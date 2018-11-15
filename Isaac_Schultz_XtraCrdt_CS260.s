# Homework 4
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
Zero:							.float 0.0		
Array:							.float 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0
AverageMessage:					.asciiz "Average: "
ElementsMessage:				.asciiz "Array Elements:\n"

        .text        
main:

	la $a0, Array			# Loading addresses of our data into registers $t0-$t2
	la $a1, AverageMessage

	sub $a1, $a1, $a0		# Subtracts the address of AverageMessage from the address of Array.
	srl $a1, $a1, 2			# Divides $t1 by 4 by shifting bits to the right by 2
							# $t1 is now the size of the array in words.

	jal ArrayAverage					# Calls the semiPerimeter function
										#	$f0 is now the average of the array's elements
		
	jal ArrayPrint						# Calls the isTriangle function
										#	$v0 is now a bool representing the triangle.
										
	
	# End program
		li $v0, TERMINATE_SERV
		syscall
		
.end main




# Function that calculates the average of an array of floats.
# Arguments:	$a0:	Address of the array.
#				$a1:	Number of elements in the array.
# Returns:		$f0:	The average of the array.
# Uses  registers: $t0-$t2
ArrayAverage:

	li $t0, 0 			# Initialize the loop counter
	l.s $f0, Zero		# Initialize the running average to 0
	
	Loop:
	
		beq $t0, $a1, End		# End condition for the loop. When the loop counter reaches $a1.
								# $a1 is the number of elements in the array.

		l.s $f1, 0($a0)			# Loads a float from the array
	
		add $f0, $f0, $f1		# Increases the total the current float.
		
		add $a0, $a0, 4			# Increment the $a0 pointer by 1 word.
		addi $t0, $t0, 1		# Increment the loop counter
		b Loop 					# Branch back to Loop:
		
	End:
		mtc1.s $a1, $f1			# Move the number of elements to a float register
		cvt.w.s	$f1, $f1		# Convert the integer $a1 to a float $f1
		div.s $f0, $f0, $f1		# Divide the total by the number of elements to get the average.
		
		jr $ra					# Jump back to the return address
.end ArrayAverage




# Function that determines whether 3 sides can form a triangle.
# Arguments:	SemiPerimiter						(at $ap + 0)	or	0($sp)
#				Length of side a					(at $sp + 4)	or	4($sp)
#				Length of side b					(at $sp + 8)	or	8($sp)
#				Length of side c					(at $sp + 12)	or	12($sp)
#				
#
# Returns:		bool if the sidelengths are a triangle in $v0
#					returns 0 if it is not a triangle.
#					returns 1 if it is a triangle.
#
# Uses  registers: $f0-$f1, $t0-$t1
isTriangle:
	
	li $t0, 0					# Initializing loop counter to 0
	move $t1, $sp				# Saves the address of the stack pointer
								#	so it can be iterated separate from $sp
	addi $t1, 4					# set $t1 to point to first sidelength.
	l.s $f0, 0($sp)				# saves the semiPerimeter in $f0
	
Loop:
	
	beq $t0, 3, WasATriangle	# End condition for the loop. Should only happen if 
								#	all the sides were less than the semiperimiter.

	l.s $f1, ($t1)				# Load the float on the bottom of the stack
	c.le.s $f0, $f1		 		# End the loop if one of the sides is >= semiperimiter
	bc1t WasNotTriangle
				
	addi $t1, $t1, 4			# Up the stack counter to look 
	addi $t0, $t0, 1			# Increment the loop counter
	b Loop 						# Branch back to Loop:
		
WasATriangle:
	li $v0, 1					# Return 1 when the sides are a triangle
	b End
	
WasNotTriangle:
	li $v0, 0					# Return 0 if they arent a triangle.
	b End
	
End:
	jr $ra						# Jump back to the return address
	
.end isTriangle




# Function that determines the area of a triangle using its sidelengths 
# and the pre-calculated semiPerimeter.
# Arguments:	SemiPerimiter						(at $ap + 0)	or	0($sp)
#				Length of side a					(at $sp + 4)	or	4($sp)
#				Length of side b					(at $sp + 8)	or	8($sp)
#				Length of side c					(at $sp + 12)	or	12($sp)
#
# Returns:		Area of the triangle as a float in $f0
#
# Uses  registers: $f0-$f3
triangleArea:
	
	l.s $f0, 0($sp)			# saves the semiPerimeter in $f0
	
	l.s $f1, 4($sp)			# Load the float on the bottom of the stack
	sub.s $f1, $f0, $f1		# $f1 = semiperimeter - side a
	
	l.s $f2, 8($sp)			# Load the next sidelength off the stack
	sub.s $f2, $f0, $f2		# $f2 = semiperimeter - side b
	
	l.s $f3, 12($sp)		# Load the last sidelength off the stack
	sub.s $f3, $f0, $f3		# $f3 = semiperimeter - side c
	
	mul.s $f0, $f0, $f1		# $f0 = (semiperimiter) * (semiperimeter - side a)
	mul.s $f1, $f2, $f3		# $f1 = (semiperimeter - side b) * (semiPerimeter - side c)
	
	mul.s $f0, $f0, $f1		# $f0 = (semiperimiter) * (semiperimeter - side a)
							#		* (semiperimeter - side b) * (semiPerimeter - side c)
								
	sqrt.s $f0, $f0			# $f0 = SQRT[ (semiperimiter) * (semiperimeter - side a)
							#	  * (semiperimeter - side b) * (semiPerimeter - side c) ]
		
	jr $ra					# Jump back to the return address
	
.end triangleArea