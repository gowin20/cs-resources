#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void moveString(char* p1, char* p2){
	int i;
	int length = strlen(p1);

	for(i = 0; i < length; i++){
		p2[i] = *(p1+i);
	}
}

int main() {
	/* string to be moved */
	char loc[] = "Welcome to CS 33 Fall 2019!";

	/* new desired location of string */
	char* newloc;

	/* move string from old location to new */
	moveString(loc, newloc);

	/* print content of new location (should be original string) */
	printf("%s\n", newloc);

	return 0;
}
