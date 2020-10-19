OPTIMIZE = -O1
CC=gcc

randmain: randmain.c randcpuid.c
	$(CC) randmain.c randcpuid.c -o randmain -ldl -Wl,-rpath="." 
	#$(pwd)

randlibhw.so: randlib.h randlibhw.c
	$(CC) randlibhw.c $(OPTIMIZE) -o randlibhw.so -fPIC -shared 

randlibsw.so: randlib.h randlibsw.c
	$(CC) randlibsw.c $(OPTIMIZE) -o randlibsw.so -fPIC -shared 	



#-ldl -Wl,-rpath=$PWD