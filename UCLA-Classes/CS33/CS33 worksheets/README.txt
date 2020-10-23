=================================
DISCUSSION 0 EXERCISE: Using GDB
=================================

1 - Description:

The code in main.c causes a segmentation fault when executed (interruption caused by a memory access violation).

Your job is to use GDB to find the cause of the segmentation fault and fix the error, such that the program does 
what it is intended to do (copy a string from one location to another).

The purpose of the exercise is to introduce you to debugging with GDB, which will be crucial throughout the course.


2 - Getting started:

     * Use command 'make' to compile the executable called 'main'.
     * To open the program with GDB, use 'gdb main'.
     * To set a breakpoint at a function 'foo', use 'break foo'.
     * To start running the program on GDB,  use 'run'.
     * To see the code (TUI mode), use 'layout next'. You can also use the shortcut Ctrl-x Ctrl-a to switch in/out
       of this view. 
     * To step over to the next line of the C code, use 'next'.
     * To step into a function call, use 'step'.
     * To stop execution of the program, use 'kill'.
     * To quit GDB, use 'quit'.


3 - Further instructions:

Feel free to discuss and look up other GDB commands that can help you. Some ideas are:

     * How to read the values of variables at the point in the execution.
     * How to set breakpoints at certain line numbers or instruction addresses.
     * How to read the contents of memory addresses.
     * How to delete/disable/enable breakpoints.
     * Extra: how to see the assembly code of the C code.

GDB cheatsheet:
https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf
