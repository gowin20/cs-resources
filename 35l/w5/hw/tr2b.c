#include <stdio.h>

int main(int argc, const char *argv[])
{

	char* from = argv[1];
	char * to = argv[2];

	if (from == NULL || to == NULL || argv[3] != NULL)
	{
		fprintf(stderr, "Error: tr2b takes exactly two arguments\n");
		exit(1);
	}

	int fromLen = strlen(from);

	if (fromLen != strlen(to))
	{
		fprintf(stderr, "Error: args must have the same number of bytes\n");
		exit(1);
	}

	//printf("1: %s, 2: %s", from, to);

	int i;
	int j;
	for (i = 0; i < (fromLen-1); i++)
	{
		for (j = (i+1); j < fromLen; j++)
		{
			if (from[i] == from[j])
			{
				fprintf(stderr, "Error: 'from' can have no duplicate bytes\n");
				exit(1);
			}
		}
	}
	char ch[1]; //I initially tried to use a pointer, but it would simply put the things it reads directly onto my command line
	int n;




	int c;
	while ((c = getchar()) != EOF)
	{
		for (i = 0; i < fromLen; i++)
		{
			if (c == from[i])
			{
				c = to[i];
				break;
			}
		}
		putchar(c);
	}

}	