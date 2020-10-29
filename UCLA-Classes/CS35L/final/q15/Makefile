
default: libcomputechar.a libaddstr.so libsubstr.so main

addchar.o: addchar.c
	gcc -c addchar.c

subchar.o: subchar.c
	gcc -c subchar.c

libcomputechar.a: addchar.o subchar.o
	ar -cvq libcomputechar.a addchar.o subchar.o

libaddstr.so: addstr.c libcomputechar.a
	gcc addstr.c -o libaddstr.so -fPIC -shared -lcomputechar -L.

libsubstr.so: substr.c libcomputechar.a
	gcc substr.c -o libsubstr.so -fPIC -shared -lcomputechar -L.

main: main.c computechar.h
	gcc main.c -o main -ldl -Wl,-rpath=$(PWD)

clean: 
	rm -f *.o *.so *.a main