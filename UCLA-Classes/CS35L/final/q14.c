
#include <unistd.h>
#include <stdio.h>

#define EOF (-1)
int mychar(void)
{
    char c[1];
    int status = read(0,c,1);
    if (status < 1) {
        return EOF;
    }
    return c[0];
}

int main()
{
    int c = getchar();
    int c2 = mychar();

    printf("getchar: %c, mychar: %c\n",c,c2);
}