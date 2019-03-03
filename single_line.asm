# Who: Johnny Lam
# What: single_line.asm
# Why:  Task 2 of project 1
# When: Created 3/1/2019 Due 3/3/2019 11:59 PM
# How:  $t0,$t1,$t2, and then used $v0 and $a0 just do system calls

.data

prompt:			.asciiz		"Please enter an integer: "

.ALIGN 2					# memory aligned 2^2 for word type

array: 		.space		80		# reserving 80 bytes
array_size:	.word		20		# 4 bytes a word, 20 words = 80 bytes

.text
.globl main


main:	# program entry

la $t0, array		# loads the address of array into t0
la $t1, array_size	# grabbing the address of array_size
la $t3, prompt		# stores the address of prompt in register t3
lw $t1, 0($t1)		# t1 = 20 
sll $t1, $t1, 2		# shift left logical 2 digits over, 0001 01000 -> 0101 0000 = 80(decimal)
addu $t1, $t0, $t1	# t1 is now the value of 80 + the value of the array 

inputLoop:
slt $t2, $t0, $t1		# if t0 < t1, set t2 = 1 else t2 = 0, start at 0, increment 4 until it hits 80 (20 iterations)
beq $t2, $0, exit_inputLoop 	# branch to exit_inputLoop if t2 = 0; 20<20, t2 = 0 now
	
# Asks for input

li $v0, 4			# system call to print out the prompt
move $a0,$t3			# a0 = t3, which is prompt
syscall				# output prompt asking to input integer

li $v0, 5			# tell system to read an input
syscall				# gets value input

sw $v0, 0($t0)			# store the input into t0
addiu $t0, $t0, 4		# interates to the next word position (we use 4 b/c it's a word)

j inputLoop			# go back to start of loop

exit_inputLoop:
	
			
la $t0, array

outputLoop:			#similar to the inputLoop, just brought it over but for output this time

slt $t2, $t0, $t1 		# if t0 < t1, set t2 to 1 else t2 = 0 (20 iterations)
beq $t2, $0, exit_outputLoop

lw $t2, 0($t0)			# t2 contains the values of t0

li $v0, 1		# print value
move $a0, $t2		#a0 = t2, t2 is the integer to be printed
syscall			# prints value inputed

li $a0, ' '		# a0 = ' '
li $v0, 11		# will now print a space
syscall			# print new line

addiu $t0, $t0, 4	# iterate to next word in array

j outputLoop		# go back to start of outputloop


exit_outputLoop:


li $v0, 10		# terminate the program
syscall
	
