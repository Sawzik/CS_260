# Extra Credit 1
# Isaac Schultz

# Constants
NL  = '\n'		# Newline
TAB = '\t'		# Tab
SPACE = ' '		# space

# System services
PRINT_INT_SERV  = 1
PRINT_FLT = 2
PRINT_STR_SERV  = 4
READ_INT_SERV   = 5
TERMINATE_SERV  = 10
PRINT_CHAR_SERV = 11

        .data  
Zero:							.float 0.0		
Array:							.float 5.4345, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0
AverageMessage:					.asciiz "Average: "
DataMessage:					.asciiz "Array Data: "
ElementsMessage:				.asciiz "Array Elements:\n"

        .text        
main:

	la $a0, Array						# Loading addresses of our data into registers
	la $a1, AverageMessage

	sub $a1, $a1, $a0					# Subtracts the address of AverageMessage from the address of Array.
	srl $a1, $a1, 2						# Divides $t1 by 4 by shifting bits to the right by 2
										# $t1 is now the size of the array in words.

	jal ArrayAverage					# Calls the semiPerimeter function
										#	$f0 is now the average of the array's elements
										
	# Display average message
	la $a0, AverageMessage
	li $v0, PRINT_STR_SERV
	syscall
	
	# Display the floating average
	mov.s $f12, $f0
	li $v0, PRINT_FLT
	syscall
	
	# Display Newline
	la $a0, NL
	li $v0, PRINT_CHAR_SERV
	syscall	
	
	# Display Array Data before data message
	la $a0, DataMessage
	li $v0, PRINT_STR_SERV
	syscall
	
	la $a0, Array						# Preparing for print function call
		
	jal ArrayPrint						# Calls the ArrayPrint function
										
	# Display Newline
	la $a0, NL
	li $v0, PRINT_CHAR_SERV
	syscall	
	
	# End program
	li $v0, TERMINATE_SERV
	syscall
		
.end main




# Function that calculates the average of an array of floats.
# Arguments:	$a0:	Address of the array.
#				$a1:	Number of elements in the array.
# Returns:		$f0:	The average of the array.
# Uses  registers: $t0, $f0, $f1, $f12
ArrayAverage:

	li $t0, 0 			# Initialize the loop counter
	l.s $f0, Zero		# Initialize the running average to 0
	
	AverageLoop:
	
		beq $t0, $a1, AverageEnd		# End condition for the loop. When the loop counter reaches $a1.
										# $a1 is the number of elements in the array.

		l.s $f1, 0($a0)					# Loads a float from the array
	
		add.s $f0, $f0, $f1				# Increases the total the current float.
		
		addi $a0, $a0, 4				# Increment the $a0 pointer by 1 word.
		addi $t0, $t0, 1				# Increment the loop counter
		b AverageLoop 					# Loop Again
		
	AverageEnd:
	
		mtc1 $a1, $f1					# Move the number of elements to a float register
		cvt.s.w	$f1, $f1				# Convert the integer $a1 to a float $f1
		div.s $f0, $f0, $f1				# Divide the total by the number of elements to get the average.
		
		jr $ra							# Jump back to the return address
.end ArrayAverage




# Function that displays each element of an array of floats
# Arguments:	$a0:	Address of the array.
#				$a1:	Number of elements in the array.
# Returns:		N/A
# Uses  registers: $t0, $t1, $f0, $f12
ArrayPrint:

	li $t0, 0 						# Initialize the loop counter
	move $t1, $a0					# Save the address of the array
	
	PrintLoop:
	
		beq $t0, $a1, PrintEnd		# End condition for the loop. When the loop counter reaches $a1.
									# $a1 is the number of elements in the array.
	
		l.s $f0, 0($t1)				# Loads a float from the array
		
		# Display the floating point calculated area.
		mov.s $f12, $f0
		li $v0, PRINT_FLT
		syscall
			
		# Display space
		la $a0, SPACE
		li $v0, PRINT_CHAR_SERV
		syscall	
		
		addi $t1, $t1, 4			# Increment the $t1 pointer by 1 word.
		addi $t0, $t0, 1			# Increment the loop counter
		b PrintLoop 				# Loop again
		
	PrintEnd:
		
		jr $ra						# Jump back to the return address
.end ArrayPrint