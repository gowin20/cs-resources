#include <stdio.h>
#include <stdlib.h>
//#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int frobcmp(char const * a, char const * b)
{
	char * a1 = a;
	char * b1 = b;

	// bitwise xor with 0x2A
	char vA = *a1 ^ 0x2A;
	char vB = *b1 ^ 0x2A;

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

int main()
{

	char** lines = (char**)malloc(0);
	char* currentLine = (char*)malloc(0);

	int numLines = 0;
	int lineSize = 0;
	int isFile;
	int readReport;

	if (isatty(0))
		isFile = 0;
	else
	{
		isFile = 1;
		struct stat fileStat;
		fstat(0, &fileStat);
//		printf("Size: %i", (int)fileStat.st_size);

		char* data = (char*)malloc(fileStat.st_size);

		int readReport = read(0,data,fileStat.st_size);

		int curLength = 0;
		for (int i = 0; i < fileStat.st_size; i++)
		{
			if (data[i] == ' ')
			{
				//i++;
				lines = realloc(lines,(numLines + 1) * sizeof(char*));
//				checkForFree(lines, data, numLines);
				lines[numLines] = data[i - curLength];


				putchar(lines[numLines]);
				numLines++;
			}
			else curLength++;
		}

		printf("numlines is %i", numLines);

		return 0;
	}


	char ch[1];
	while ((readReport = read(0,ch,1)) > 0)
	{

		if (ch[0] == ' ')
		{
			//if space, reallocate the entire lynes array to have an additional line

			//append a space at the end of each line, for frobcmp
			currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));

			checkForFree(lines, currentLine, numLines);

			currentLine[lineSize] = ' ';

			//place our new line inside our lines array
			
			lines = realloc(lines, (numLines + 1) * sizeof(char*));
			
			checkForFree(lines, currentLine, numLines);
			

			
			lines[numLines] = currentLine;
			numLines++;
			//reset currentLine to parse next line
			currentLine = (char*)malloc(0);
			lineSize = 0;
			
		}
		else
		{
		  currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));

	      checkForFree(lines, currentLine, numLines);

		  
		  currentLine[lineSize] = ch[0];
		  lineSize++;		  
		}
	}


	//TODO : FIX THIS
	if (readReport == 0)
	{
		//append a space to the final word as well
		if (ch[0] != ' ')
		{
			currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));

			checkForFree(lines, currentLine, numLines);

			currentLine[lineSize] = ' ';
		}
		
		
		lines = realloc(lines, (numLines + 1) * sizeof(char*));
		checkForFree(lines, currentLine, numLines);

		  


		lines[numLines] = currentLine;
		numLines++;
		//frees currentLine. probably not necessary
		currentLine = (char*)malloc(0);
		free(currentLine);
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

	printf("%s nice guys, %i", "we got here", numLines);

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


	freeArray(lines, numLines);
	//int n = ((*a^0x2A) == ' ' || (*b^0x2A) == ' ');

//	printf("a is %c and b is %c", memfrob(a), memfrob(b));

	//int out = frobWrap(a, b);

	//printf("\n\n output: %i\n", out);
}

