# ICS3203-CAT2-Assembly-151675-Mercy-Mwaniki

This README provides an overview of the assembly programming tasks, including their purposes, compilation and execution instructions, and challenges encountered during implementation.

---

## 1. Control Flow and Conditional Logic

### Purpose
This program takes a number as input from the user and determines whether it is **POSITIVE**, **NEGATIVE**, or **ZERO** using branching and comparison logic.

### Compilation and Execution
1. Open a terminal in the directory containing `control_flow.asm`.
2. Compile the program:
   ``` bash
   nasm -f elf64 control_flow.asm -o control_flow.0
   ld control_flow.o -o control_flow
   ```
  4. Run the program
     ``` bash
     ./control_flow
      ```
     
### Challenges
Conditional vs. Unconditional Jumps: Deciding when to use conditional (JMP, JG, JL) versus unconditional (JMP) instructions for clarity and efficiency.
Ensuring proper program flow by handling all edge cases (e.g., input of zero).

## 2. Array Manipulation with Looping and Reversal

### Purpose
This program accepts an array of integers, reverses the array in place using a loop, and outputs the reversed array without allocating additional memory.

### Compilation and Execution
1. Open a terminal in the directory containing `array_reversal.asm`.
2. Compile the program:
    ``` bash
   nasm -f elf64 array_reversal.asm -o array_reversal.0
   ld array_reversal.o -o array_reversal
   ```
  4. Run the program
     ``` bash
     ./array_reversal
      ```
     
### Challenges
Managing array pointers and avoiding additional memory allocation.
Handling edge cases, such as an array with an odd number of elements.
Efficient use of registers to perform swaps during reversal.

##3. Modular Program with Subroutines for Factorial Calculation

###Purpose
This program calculates the factorial of a user-input number using a subroutine. The subroutine uses the stack for register preservation and modular design.

###Compiling and execution
1. Open a terminal in the directory containing `factorial.asm`.
2. Compile the program:
    ``` bash
   nasm -f elf64 factorial.asm -o factorial.0
   ld factorial.o -o factorial
   ```
  4. Run the program
     ``` bash
     ./factorial
      ```
     
### Challenges
Managing the stack to preserve and restore register states.
Debugging stack overflows caused by incorrect PUSH/POP order.
Ensuring the final factorial result is stored in a general-purpose register.

## Data Monitoring and Control Using Port-Based Simulation

###Purpose
This program simulates a control system that monitors a "sensor value" from memory or input port and performs the following actions:

Turns on a motor if the value is low.
Triggers an alarm if the value is high.
Stops the motor if the value is moderate.

###Compiling and execution
1. Open a terminal in the directory containing `sensor.asm`.
2. Compile the program:
    ``` bash
   nasm -f elf64 sensor.asm -o sensor.0
   ld sensor.o -o sensor
   ```
  4. Run the program
     ``` bash
     ./sensor
      ```
     
### Challenges
Accurately simulating memory locations for ports and sensor input.
Implementing conditional logic to decide motor and alarm status.
Ensuring proper memory manipulation without overwriting critical values.
