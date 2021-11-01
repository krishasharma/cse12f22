Krisha Sharma
krvsharm
Fall 2021
Lab 2: Simple Data Path

-----------
DESCRIPTION

In this lab, the objective is to build a sequential logic circuit and introduce data paths. In this lab, a register file containing four, 4-bit registers, will be built. Each of the four registers has an address (0b00 -> 0b11) and stores a 4-bit value. The value saved to a destination register (write register) will come from one of two sources, the keypad user input, or the output of the ALU. The ALU in this system is a 4-bit bitwise left rotation (left circular shift) circuit that takes two of the register values as inputs (read registers). The MML library ALU cannot be used. Instead it is required to build one out of maxes or logic gates. .
 

-----------
FILES

-
Lab2.lgi

This file will open an MML page leading to the implemented sequential logic circuit. 

-----------
INSTRUCTIONS

This program is intended to be run using the MML (Multimedia Logic) which is a schematic entry logic simulation program. From the user interface, the user will select the data source (source select) and the addresses of the read and write registers 