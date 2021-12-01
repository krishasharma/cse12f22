# Fall 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

###########################################################################################################
# Created by: Sharma, Krisha
# krvsharm
# 13 November 2021 
# 
# Assignment: Lab 4: Functions and Graphics 
# CSE 12, Computer Systems and Assembly Language # UC Santa Cruz, Fall 2021 
# 
# Description: This program will allow users to change the background color of the display, and “draw” 
#              horizontal and vertical lines on the display.. 
# 
# Notes: This program is intended to be run from the MARS IDE. 
###########################################################################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	push(%input)                                               # stores input in stack pointer in main memory
	lhu %y, 0($sp)                                             # uses stack pointer to go to inital memory 0 and load into register y 
	lhu %x, 2($sp)                                             # uses stack pounter to go to memory 2 and load into register x 
	pop(%input)                                                # brings stack pointer back to 0 
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %x, %x, 16                                             # shifts register containing 0x000000XX to the left 16 bits 
	or %output, %x, %y                                         # takes register %x and register %y and compares them using or commmand, outputing 
	                                                           # the combination of both
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	push(%x)                                                   # macro that stores the value in %x on the stack and moves the stack pointer
	push(%y)                                                   # macro that stores the value in %y on the stack and moves the stack pointer
	push($t0)                                                  # macro that stores the value in $t0 on the stack and moves the stack pointer
	
	li $t0, 0xFFFF0000                                         # register containing origin hexadecimal 
	mulu %y, %y, 128                                           # multiplies register %y containing 0x000000YY with 128 and sets it to register %y  
	add %x, %x, %y                                             # adds updated register %y with %x and updates value to register %x 
	mulu %x, %x, 4                                             # adds register %x and 4 and updates value in reigster %x 
	add %output, $t0, %x                                       # adds register $t0 (origin register) and register %x and updates to the output value 
	 
	pop($t0)                                                   # macro takes the value on top of the stack and loads it into $t0 then moves the stack pointer
	pop(%y)                                                    # macro takes the value on top of the stack and loads it into %y then moves the stack pointer
	pop(%x)                                                    # macro takes the value on top of the stack and loads it into %x then moves the stack pointer
.end_macro

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate) 
	
 	li $t0, 0xFFFF0000                                         # $t0 contains the origin hexadecimal/starting memory location to color the bitmap  
	li $t1, 16385                                              # assigns register $t1 with the value of 128 * 128 = 16384, increased by one
	li $t3, 1                                                  # initalizes register $t3 with the value 1 
	fillcolor: 
		sw $a0, ($t0)                                      # given a color in register $a0, color the pixel at the memory location in $t0 
		addi $t0, $t0, 4                                   # by adding 4 we can increases the memory register by 1 
		addi $t3, $t3, 1                                   # i = i + 1, counter where $t3 is being increased by 1 every time the function loops through
		beq $t3, $t1, exit                                 # if register $t0 is equal to 128*128, exit the program, else increase the count 
		nop
		j fillcolor                                        # loops back to the start of the clear_bitmap funciton 
	exit: 
		jr $ra
	 
#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates ($a0 $t4 $t5)                               # macro input register is at $a0 and the output of 0x000000XX and 0x000000YY are stored in $t4 and $t5
	getPixelAddress ($t6 $t4 $t5)                              # marco output places memory address from $t4 and $t5 into register $t6
	sw $a1, ($t6)                                              # stores the contents of $t6 (the memory address) in register $a1 which also holds the color of the pixel 
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t1)                                                  # macro that stores the value in $t1 on the stack and moves the stack pointer
	push($t2)                                                  # macro that stores the value in $t2 on the stack and moves the stack pointer
	push($t3)                                                  # macro that stores the value in $t3 on the stack and moves the stack pointer
	
	getCoordinates($a0 $t1 $t2)                                # takes the pixel coodinate and gets the coordinates using getCoordinate macro 
	getPixelAddress($t3 $t1 $t2)                               # returns the pixel adress in register $t3 using 0x000000XX and 0x000000YY from getCoordinate
	lw $v0, ($t3)                                              # sets the contents of $t3 (the memory address) to register $v0 which returns the pixel color  
	
	pop($t3)                                                   # macro takes the value on the top of the stack and loads it into $t3 then moves the stack pointer
	pop($t2)                                                   # macro takes the value on the top of the stack and loads it into $t2 then moves the stack pointer
	pop($t1)                                                   # macro takes the value on the top of the stack and loads it into $t1 then moves the stack pointer
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t5)                                                  # macro that stores the value in $t5 on the stack and moves the stack pointer
	push($t2)                                                  # macro that stores the value in $t2 on the stack and moves the stack pointer
	push($t4)                                                  # macro that stores the value in $t4 on the stack and moves the stack pointer
	push($t3)                                                  # macro that stores the value in $t3 on the stack and moves the stack pointer
	li $t5, 0                                                  # initalizes $t5 as counter with the starting value of 0
	li $t2, 128                                                # initalizes $t2 with the length/width of the bitmap 
	li $t4, 0x00000000                                         # zero for the x coord 
	makehorizontal: 
		getPixelAddress ($t3 $t4 $a0)                      # macro that converts the x & y coordinates into the memory address  
		sw $a1, ($t3)                                      # stores the memory adress in the color register $a1 
		addi $t5, $t5, 1                                   # i = i + 1, inital counter 
		addi $t4, $t4, 1                                   # i = i + 1, increases the x coordinate by 1 every time 
		beq $t5, $t2, end                                  # if the counter ($t0) is equal to the register value in $t2, branch to end, else continue 
		j makehorizontal                                   # jumps back to the start of the makehorizontal function, acting as a for loop 
	end: 
		pop($t3)                                           # macro takes the value on the top of the stack and loads it into $t3 then moves the stack pointer
		pop($t4)                                           # macro takes the value on the top of the stack and loads it into $t4 then moves the stack pointer
		pop($t2)                                           # macro takes the value on the top of the stack and loads it into $t2 then moves the stack pointer
		pop($t5)                                           # macro takes the value on the top of the stack and loads it into $t5 then moves the stack pointer
		jr $ra

#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t5)                                                  # macro that stores the value in $t5 on the stack and moves the stack pointer
	push($t2)                                                  # macro that stores the value in $t2 on the stack and moves the stack pointer
	push($t4)                                                  # macro that stores the value in $t4 on the stack and moves the stack pointer
	push($t3)                                                  # macro that stores the value in $t3 on the stack and moves the stack pointer
	li $t5, 0                                                  # initalizes $t5 as counter with the starting value of 0 
	li $t2, 128                                                # initalizes $t2 with the length/width of the bitmap 
	li $t4, 0x00000000                                         # zero for the y coord 
	makevertical: 
		getPixelAddress ($t3 $a0 $t4)                      # macro that converts the x & y coordinates into the memory address  
		sw $a1, ($t3)                                      # stores the memory adress in the color register $a1 
		addi $t5, $t5, 1                                   # i = i + 1, inital counter 
		addi $t4, $t4, 1                                   # i = i + 1, increases the x coordinate by 1 every time 
		beq $t5, $t2, terminate                            # if the counter ($t0) is equal to the register value in $t2, branch to terminate, else continue 
		j makevertical                                     # jumps back to the start of the makevertical function, acting as a for loop
	terminate:
		pop($t3)                                           # macro takes the value on the top of the stack and loads it into $t3 then moves the stack pointer
		pop($t4)                                           # macro takes the value on the top of the stack and loads it into $t4 then moves the stack pointer
		pop($t2)                                           # macro takes the value on the top of the stack and loads it into $t2 then moves the stack pointer
		pop($t5)                                           # macro takes the value on the top of the stack and loads it into $t5 then moves the stack pointer
		jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)

    	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
    	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
    	# give the appearance of the center being transparent.

    	# Note: Remember to use push and pop in this function to save your t-registers
    	# before calling any of the above subroutines.  Otherwise your t-registers 
    	# may be overwritten.

    	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
    	
    	push($t0)                                                  # macro that stores the value in $t0 on the stack and moves the stack pointer
    	push($t1)                                                  # macro that stores the value in $t1 on the stack and moves the stack pointer
    	push($t2)                                                  # macro that stores the value in $t2 on the stack and moves the stack pointer
    	push($t3)                                                  # macro that stores the value in $t3 on the stack and moves the stack pointer
    	push($t4)                                                  # macro that stores the value in $t4 on the stack and moves the stack pointer
    	
    	jal get_pixel                                              # jumps to get_pixel function 
    	move $t7, $v0                                              # moves the contents of $v0 to register $t7
    	getCoordinates($a0, $t0, $t1)                              # x ($t0) & y ($t1) coordinates are being stored in register $t0 and $t1, given from register $a0
    	getPixelAddress($t3, $t0, $t1)                             # macro that converts pixel coordinates into the memory address, takes in x & y coordinates in register $t0 and $t1 and places memory address in $t2
    	
    	move $a0, $t0                                              # moves the contents of register $t0 (the x & y coord of intersection) in register $a0 in the format required for draw_vertical_line
    	jal draw_vertical_line                                     # jumps to draw_vertical_line function
	
    	move $a0, $t1                                              # moves the contents of register $t1 (the x & y coord of intersection) in register $a0 in the format required for draw_horizontal_line 
    	jal draw_horizontal_line                                   # jumps to draw_horizontal_line function 
    	
    	formatCoordinates($a0, $t0, $t1)                           # formats the x & y coordinates into 0x00XX00YY format needed for the draw pixel function
    	move $a1, $t7                                              # moves the contence of the register $t7 into the register $a1 which also holds the color in format (0x00RRGGBB) 
    	jal draw_pixel                                             # jumps to draw_pixel function 

	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
  	# Add a pop before the below jump return (and push somewhere above) to fix this.
	
    	pop($t4)                                                   # macro takes the value on the top of the stack and loads it into $t4 then moves the stack pointer
    	pop($t3)                                                   # macro takes the value on the top of the stack and loads it into $t3 then moves the stack pointer
    	pop($t2)                                                   # macro takes the value on the top of the stack and loads it into $t2 then moves the stack pointer
    	pop($t1)                                                   # macro takes the value on the top of the stack and loads it into $t1 then moves the stack pointer
    	pop($t0)                                                   # macro takes the value on the top of the stack and loads it into $t0 then moves the stack pointer
	pop($ra)                                                   # macro takes the value on the top of the stack and loads it into $ra then moves the stack pointer
    	jr $ra
	
