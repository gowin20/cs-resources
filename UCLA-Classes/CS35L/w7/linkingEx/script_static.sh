#!/usr/bin/env sh

# Create the object file. -c means no linking
gcc -Wall -g -c -o libhello-static.o libhello.c

# Create an archive, i.e. a static library
ar rcs libhello-static.a libhello-static.o

# object file for our driver program
gcc -Wall -g -c demo.c -o demo.o

# Static linking
gcc -g -o demo_static demo.o -L "$(pwd)" -lhello-static

# run
./demo_static
