#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include <stdio.h>

#include <immintrin.h>
#include <dlfcn.h>

#include "randcpuid.h"

static bool
writebytes (unsigned long long x, int nbytes)
{
  int ndigits = nbytes * 2;
  do
    {
      if (putchar ("0123456789abcdef"[x & 0xf]) < 0)
	return false;
      x >>= 4;
      ndigits--;
    }
  while (0 < ndigits);

  return 0 <= putchar ('\n');
}



/* Main program, which outputs N bytes of random data.  */
int
main (int argc, char **argv)
{
  /* Check arguments.  */
  bool valid = false;
  long long nbytes;
  if (argc == 2)
    {
      char *endptr;
      errno = 0;
      nbytes = strtoll (argv[1], &endptr, 10);
      if (errno)
	perror (argv[1]);
      else
	valid = !*endptr && 0 <= nbytes;
    }
  if (!valid)
    {
      fprintf (stderr, "%s: usage: %s NBYTES\n", argv[0], argv[0]);
      return 1;
    }

  /* If there's no work to do, don't worry about which library to use.  */
  if (nbytes == 0)
    return 0;

  /* Now that we know we have work to do, arrange to use the
     appropriate library.  */

  unsigned long long (*rand64) (void);

  
  void *lib_handle;
  char *error;
  if (rdrand_supported ())
    {
    	lib_handle = dlopen("randlibhw.so", RTLD_LAZY);
    	if (!lib_handle)
    	{
    		//error linking hardware library
    		fprintf (stderr, "Error linking hardware library\n");
    		return 1;
    	}	
    }
  else
    {
      //(unsigned long long (*) (void))
   	  lib_handle = dlopen("randlibsw.so", RTLD_LAZY);
   	  if (!lib_handle)
   	  {
   	  	//error linking software library
		fprintf (stderr, "Error linking software library\n");
		return 1;
   	  }
    }

  rand64 = dlsym(lib_handle, "rand64");
  error = dlerror();
  if (error != NULL)
    {
      fprintf (stderr, error);
      return 1;
      //dlsym software error
    }
 
  int wordsize = sizeof rand64 ();
  int output_errno = 0;

  do
    {
      unsigned long long x = rand64 ();
      int outbytes = nbytes < wordsize ? nbytes : wordsize;
      if (!writebytes (x, outbytes))
	{
	  output_errno = errno;
	  break;
	}
      nbytes -= outbytes;
    }
  while (0 < nbytes);

  if (fclose (stdout) != 0)
    output_errno = errno;

  if (output_errno)
    {
      errno = output_errno;
      perror ("output");
      dlclose(lib_handle);
      return 1;
    }

  dlclose(lib_handle);
  return 0;
}
