#!/bin/sh
# Dynamically loaded library demo

gcc -fPIC -Wall -g -c libhello.c

# -lc links against the C library
# -Wl,option1,option2 passes option1 and option2 to the linker, etc.
gcc -g -shared -Wl,-soname,libhello.so.0 -o libhello.so.0.0 libhello.o -lc

/sbin/ldconfig -n .

ln -sf libhello.so.0 libhello.so

gcc -Wall -g -c demo_dynamic.c

# link to the dynamic linking library libdl
gcc -g -o demo_dynamic demo_dynamic.o -ldl -Wl,-rpath="$(pwd)"

./demo_dynamic

