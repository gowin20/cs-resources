OPTIMIZE = -O1
CC=gcc

randmain: randmain.c randcpuid.c
	$(CC) $(CFLAGS) randmain.c randcpuid.c -g -o randmain -ldl -Wl,-rpath=$(PWD)

randlibhw.so: randlib.h randlibhw.c
	$(CC) $(CFLAGS) randlibhw.c -o randlibhw.so -fPIC -shared 

randlibsw.so: randlib.h randlibsw.c
	$(CC) $(CFLAGS) randlibsw.c -o randlibsw.so -fPIC -shared 	



#-ldl -Wl,-rpath=$PWD
