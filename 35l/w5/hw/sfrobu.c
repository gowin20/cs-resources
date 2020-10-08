#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int ignoreCase = 0;

int frobcmp(char const * a, char const * b)
{
	char * a1 = a;
	char * b1 = b;

	// bitwise xor with 0x2A
	char vA = *a1 ^ 0x2A;
	char vB = *b1 ^ 0x2A;

	if (ignoreCase == 1)
	{
		vA = toupper((int)vA);
		vB = toupper((int)vB);
	}

	while (vA != ' ' && vB != ' ') {

		if (vA > vB)
			return 1;
		else if (vA < vB)
			return -1;
		else
		{
			a1++;
			b1++;
			vA = *a1 ^ 0x2A;
			vB = *b1 ^ 0x2A;
		}	
	}

	if (vA == ' ' && vB == ' ')
		return 0;
	else if (vA == ' ')
		return -1;
	else
		return 1;
//	return (vA < vB) ? -1 : 1;
}

int frobWrap(const void* A, const void* B)
{
	char* a = *((char**)A);
	char* b = *((char**)B);

	return frobcmp(a, b);
}

void freeArray(char** lines, int size)
{
	for (int i = 0; i < size; i++)
	{
		free(lines[i]);
	}
       free(lines);
}

void checkForFree(char** lines, char* curLine, int size)
{
	if (curLine == NULL || lines == NULL)
	  {
	    freeArray(lines, size);
	    free(curLine);
	    fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
	    exit(1);
	  }

}

int main(int argc, const char *argv[]	)
{

	if (argc == 2)
	{
		if (strcmp(argv[1],"-f"))
		{
			fprintf(stderr, "%s", "Error: invalid argumennt. \n");
			exit(1);
		}
		else
		{
			ignoreCase = 1;			
		}
	}
	else if (argc > 2)
	{
		fprintf(stderr, "%s", "Error: sfrobu takes at most one argument '-f' \n");
		exit(1);
	}





	char** lines = (char**)malloc(0);

	char* data;

	int numLines = 0;
	int lineSize = 0;
	int isFile = 0;
	int readReport;


	struct stat fileStat;
	fstat(0, &fileStat);

	if (S_ISREG(fileStat.st_mode))
	{
		isFile = 1;
//		printf("Size: %i", (int)fileStat.st_size);
		data = (char*)malloc(fileStat.st_size * sizeof(char));

		int readReport = read(0,data,fileStat.st_size);

		if (data[fileStat.st_size - 1] != ' ')
		{
			data = realloc(data, (fileStat.st_size+1) * sizeof(char));
			data[fileStat.st_size] = ' ';
		}

		int curLength = 0;
		int i;
		for (i = 0; i < fileStat.st_size; i++)
		{
			if (data[i] == ' ')
			{
				lines = realloc(lines,(numLines + 1) * sizeof(char*));
				checkForFree(lines, data, numLines);
				lines[numLines] = &data[i - curLength];
			
				//printf("\n %i: %c \n",numLines, *lines[numLines]);

				numLines++;
				curLength = 0;
			}
			else {
				curLength++;
				//printf("L: %i, char: %c ",curLength,data[i]);
			};
		}

		lines = realloc(lines,(numLines + 1) * sizeof(char*));
		checkForFree(lines, data, numLines);
		lines[numLines] = &data[i - curLength];
		//putchar(*lines[numLines]);
		numLines++;
				//curLength = 0;
		//printf("numlines is %i", numLines);

		//return 0;
	}

	char ch[1];
	data = (char*)malloc(0);
	while ((readReport = read(0,ch,1)) > 0)
	{
		isFile = 0;
		if (ch[0] == ' ')
		{
			//if space, reallocate the entire lynes array to have an additional line

			//append a space at the end of each line, for frobcmp
			data = realloc(data, (lineSize + 1) * sizeof(char));

			checkForFree(lines, data, numLines);

			data[lineSize] = ' ';

			//place our new line inside our lines array
			lines = realloc(lines, (numLines + 1) * sizeof(char*));
			
			checkForFree(lines, data, numLines);
			
			lines[numLines] = data;
			numLines++;
			//reset data to parse next line
			data = (char*)malloc(0);
			lineSize = 0;
			
		}
		else
		{
		  data = realloc(data, (lineSize + 1) * sizeof(char));

	      checkForFree(lines, data, numLines);

		  data[lineSize] = ch[0];
		  lineSize++;		  
		}
	}
	if (readReport == 0 && isFile == 0)
	{
		//append a space to the final word as well
		if (ch[0] != ' ')
		{
			data = realloc(data, (lineSize + 1) * sizeof(char));

			checkForFree(lines, data, numLines);

			data[lineSize] = ' ';
			
			lines = realloc(lines, (numLines + 1) * sizeof(char*));
			checkForFree(lines, data, numLines);

			  
			lines[numLines] = data;
			numLines++;
			//frees data. probably not necessary
			data = (char*)malloc(0);
			free(data);

		}		
	}

	else if (readReport < 0)
	{
	  //some sort of error reading the file. Process it
	  freeArray(lines, numLines);
	  fprintf(stderr,"%s","error reading file. sux");
	  exit(1);
	}
	else
	{
		//character resembles end of line. When would this happen?
	}

	//finished reading in the file. Sort and print
	
	qsort(lines, numLines, sizeof(char*), frobWrap);

//	printf("%s nice guys, %i", "we got here", numLines);

	for (int j = 0; j < numLines; j++)
	{
		int k = 0;

		while (lines[j][k] != ' ')
		{
			write(1,&lines[j][k],1);
			//putchar(w);
			k++;
		}
		write(1," ",1);
	}


//	free(data);
	if (S_ISREG(fileStat.st_mode))
	{
		free(lines);
		free(data);
//		free(data);
	}
	else
	{
		freeArray(lines, numLines);
	}
	
//	freeArray(lines, numLines);
	//int n = ((*a^0x2A) == ' ' || (*b^0x2A) == ' ');

//	printf("a is %c and b is %c", memfrob(a), memfrob(b));

	//int out = frobWrap(a, b);

	//printf("\n\n output: %i\n", out);
}

