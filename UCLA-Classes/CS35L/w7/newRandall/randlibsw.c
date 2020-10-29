#include <stdio.h>
#include <stdlib.h>
#include "randlib.h"
/* Software implementation.  */

/* Input stream containing random bytes.  */
static FILE *urandstream;

/* Initialize the software rand64 implementation.  */

static void __attribute__((constructor)) software_rand64_init(void);

static void __attribute__((destructor)) software_rand64_fini (void);


static void
software_rand64_init (void)
{
  urandstream = fopen ("/dev/urandom", "r");
  if (! urandstream)
    abort ();
}


/* Return a random value, using software operations.  */
static unsigned long long
software_rand64 (void)
{
  unsigned long long int x;
  if (fread (&x, sizeof x, 1, urandstream) != 1)
    abort ();
  return x;
}

/* Finalize the software rand64 implementation.  */

static void
software_rand64_fini (void)
{
  fclose (urandstream);
}
