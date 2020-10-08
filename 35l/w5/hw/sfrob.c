#include <stdio.h>
#include <stdlib.h>

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

int frobWrap(void* A, void* B)
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

int main()
{

	//reads from stdin and creates an array of 'char*'s, with breaks at every space

	char** lines = (char**)malloc(0);
	char* currentLine = (char*)malloc(0);

	int numLines = 0;
	int lineSize = 0;

	int c;
	while ((c = getchar()) != EOF)
	{

		if (c == ' ')
		{
			//if space, reallocate the entire lynes array to have an additional line

			//append a space at the end of each line, for frobcmp
			currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));
			if (currentLine == NULL)
			  {
			    freeArray(lines, numLines);
			    free(currentLine);
			    fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
			    exit(1);
			  }

			currentLine[lineSize] = ' ';

			//place our new line inside our lines array
			
			lines = realloc(lines, (numLines + 1) * sizeof(char*));
			
			if (lines == NULL)
			  {
			    freeArray(lines, numLines);
			    free(currentLine);
			    fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
			    exit(1);
			  }
			

			
			lines[numLines] = currentLine;
			numLines++;
			//reset currentLine to parse next line
			currentLine = (char*)malloc(0);
			lineSize = 0;
			
		}
		else
		{
		  currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));

		  if (currentLine == NULL)
		    {
		      freeArray(lines, numLines);
		      free(currentLine);
		      fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
		      exit(1);
		    }
		  
		  currentLine[lineSize] = (char)c;
		  lineSize++;		  
		}
	}

	if (feof(stdin))
	{
		//append a space to the final word as well
		if ((char)c != ' ')
		{
			currentLine = realloc(currentLine, (lineSize + 1) * sizeof(char));

			if (currentLine == NULL)
			  {
			    freeArray(lines, numLines);
			    free(currentLine);
			    fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
			    exit(1);
			  }
			currentLine[lineSize] = ' ';
		}
		
		
		lines = realloc(lines, (numLines + 1) * sizeof(char*));
		if (lines == NULL)
		  {
		    freeArray(lines, numLines);
		    free(currentLine);
		    fprintf(stderr, "%s", "Error: unable to allocate enough memory.");
		    exit(1);
		  }
		  


		lines[numLines] = currentLine;
		numLines++;
		//frees currentLine. probably not necessary
		currentLine = (char*)malloc(0);
		free(currentLine);
	}

	else if (ferror(stdin))
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

	for (int j = 0; j < numLines; j++)
	{
		int k = 0;
		while (lines[j][k] != ' ')
		{
			printf("%c",lines[j][k]);
			k++;
		}
		putchar(' ');
	}


	freeArray(lines, numLines);
	//int n = ((*a^0x2A) == ' ' || (*b^0x2A) == ' ');

//	printf("a is %c and b is %c", memfrob(a), memfrob(b));

	//int out = frobWrap(a, b);

	//printf("\n\n output: %i\n", out);
}

