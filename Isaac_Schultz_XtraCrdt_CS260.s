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
		
	#jal ArrayPrint						# Calls the isTriangle function
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
	
		add.s $f0, $f0, $f1		# Increases the total the current float.
		
		addi $a0, $a0, 4		# Increment the $a0 pointer by 1 word.
		addi $t0, $t0, 1		# Increment the loop counter
		b Loop 					# Branch back to Loop:
		
	End:
		mtc1 $a1, $f1			# Move the number of elements to a float register
		cvt.s.w	$f1, $f1		# Convert the integer $a1 to a float $f1
		div.s $f0, $f0, $f1		# Divide the total by the number of elements to get the average.
		
		jr $ra					# Jump back to the return address
.end ArrayAverage


