###########################################################################################################
# Created by: Sharma, Krisha
# krvsharm
# 11 November 2021 
# 
# Assignment: Lab 3: ASCII-risks (Asterisks)
# CSE 12, Computer Systems and Assembly Language # UC Santa Cruz, Fall 2021 
# 
# Description: This program outputs a right triangle in asterisks whose height is based on user input. 
# 
# Notes: This program is intended to be run from the MARS IDE. 
###########################################################################################################
#Register Usage
#$t0-Counter that is used to print integers
#$t1-User input
#$t2-Asterisk counter
#
#Pseudo Code
#The code as the user for an input, store that value in $t1, then is checked if its higher than 0 and if not it branches to another function that will 
#print "invalid entry!", then jumps back to the begining of the program asking the user for another input. When the usre inpuit is above 0 then the program will
#print the integer 1 enter a new function called numbers. The code then will print a new line check if $t1 is equal to user input and branch to exit which will 
#end the program if false it will increase $t0 by one then print that value. Then the register $t2 will then become $t0-1 which is a counter for ther asterisks
#then the program jumps to ascii which will check if $t2 is equal to 0 then branch to numbers. If the conditional was false it would then print a tab and asterisk
#then the $t2 will decrease by 1. Then will jump back to ascii and is repeated until $t2 becomes 0 then jumps back to numbers and is repeated until $t1 is equal
#to $t0 and is then sent to exit and end programs.
#
#

.data 
    prompt: .asciiz "Enter the height of the pattern (must be greater than 0): \n"
    prompt2: .asciiz "Invalid input! \n" 
    emptyline: .asciiz "\n" 
    asterisk: .asciiz "*"
    test: .asciiz "test 123" 
 
.text
main: nop                               #Label that define the program "main"
    	                                #prompt the user to enter a value for the height of the pattern
    	li $v0, 4                       #load immediate $v0 with 4 indicating a print string 
    	la $a0, prompt                  #Load address of prompt into $a0
	syscall                         #used right after something to print it 
    	                                #get the height of the pattern & asking for the user input
    	li $v0, 5                       #load immediate $v0 with value 5 indicating user inout  
    	syscall                         #Shows the user input 
    	                                
    	move $t1, $v0                   #clones the value of v0 to another register (t1)
    	
	blez $t1, invalid               #conditional to see if user value is less than or equal to 0, if true branches to invalid
	nop                             #if the value is 1 or above, hardcode the 1
	li $t0, 1                       #adding 0 and 1 and placing that value into register t0, which is the counter
	li $v0, 1                       #load immediate $v0 with the value 1 ready to print an integer 
	la $a0, ($t0)                   #load address of $t0 into $a0 
	syscall                         #prints the value in $t0
	

numbers: nop                            #Label that defines the program "numbers"
	li $v0, 4                       #Load immediate $v0 with 4 indicating a print string  
	la $a0, emptyline               #Load address emptyline into $a0 
	syscall                         #prints emptyline
	                                #loop to print out the colum of numbers before the asterisk 
	beq $t1, $t0, exit              #if t0 (the counter) is euqal to t1 (the user), branch to exit 
        nop                             #else continue on 
	addi $t0, $t0, 1                #increases the number count by 1, i++ or i = i + 1
	 
	li $v0, 1                       #load immediate $v0 with the value 1 
	la $a0, ($t0)                   #load address $t0 into $a0 
	syscall                         #prints the value in $t0
	
	subi $t2, $t0, 1                #subtracts the value of $t0 by 1 and send that value in $t2
	
	j ascii                         #jumps to ascii function 
	
ascii: nop                              #label of function "ascii"
	beqz $t2, numbers               #if t2 is equal to 0, branch back to numbers 
	nop	
	li $v0, 11                      #load immediate $v0 with 11 
	la $a0, 9                       #load address with tthe value 9 indicating tabspace 
	syscall                         #print tabspace
	
	li $v0, 4                       #load immediate $v0 with 4 indicating a print string  
	la $a0, asterisk                #load address asterisk into $a0
	syscall                         #print asterisk
		
	subi $t2, $t2, 1                #decrease the asterisk count by 1, i = i - 1 
		
	j ascii	                        #loops back to the start of the ascii funciton 


invalid: nop                            #label of function "invalid"
    	li $v0, 4                       #load immediate $v0 with 4 indicating a print string
        la $a0, prompt2                 #load address prompt2 into 
        syscall                         #print the invalid prompt 
        
        j main                          #jump back to the main function 
        
        
exit: nop                               #label of function "exit"
	li $v0, 10                      #system call to end a program  
	syscall                         #will end immideatly
	
	
