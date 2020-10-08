#include <stdio.h>
#include <stdlib.h>

const char LF = '\n';

int valid_regex(const char *regex);
void process(const char *regex);
char *addchar(char *line, size_t *nchars, char ch);
char *match(const char *regex, char *line);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "mygrep: there should be only one argument\n");
        return 1;
    }
    if (!valid_regex(argv[1])) {
        fprintf(stderr, "fuck you. die\n");
        return 1;
    }
    process(argv[1]);
}

int valid_regex(const char *regex)
{
    char* c = regex;

    int literal = 0;
    while (*c != '\0')
    {
        if (*c == '\\' && literal == 0)
        {
            literal = 1;
        }
        else
        {
            literal = 0;
        }
        c++;
    }

    return literal == 1 ? 0 : 1;
    if (literal == 1) 
    {
        return 0;
    }
    else 
    {
        return 1;
    }
}

void process(const char *regex) {
    char *matched = NULL;
    char *line = NULL;
    size_t nchars = 0;

    while (1) {
        int ch = getchar();
        if (ch == EOF) {
            if (nchars != 0) {
                line = addchar(line, &nchars, LF);
                line = match(regex, line);
                nchars = 0;
            }
            break;
        }
        else {

            line = addchar(line, &nchars, ch);
            if (ch == LF) {
                line = match(regex, line);
                nchars = 0;
            }
        }
    }
}

char *addchar(char *line, size_t *nchars, char ch)
{
    line = (char*) realloc(line, ((*nchars)+1 * sizeof(char)));
        
    line[*nchars] = ch;

    (*nchars)++;

    return line;
}

char *match(const char *regex, char *line)
{
    int length = 0;
    char * c = regex;
    int literal = 0;
    while (*c !='\0')
    {
        if (*c == '\\' && literal == 0)
        { literal = 1; }
        else
        {
            literal = 0;
            length++;
        }
        c++;
    }
    int start, matchLen=0;
    for (start = 0; line[start + length-1] != LF; start++)
    {
        matchLen = 0;

        literal = 0;
        int charNum = matchLen;
        while (matchLen < length)
        {
            if (regex[charNum] == '\\' && literal == 0)
            {
                literal = 1;
            }
            else if (regex[charNum] == '.' && literal == 0)
            {
                matchLen++;
            }
            else if (line[start + matchLen] == regex[charNum])
            {
                literal = 0;
                matchLen++;
            }
            else { break; }

            charNum++;

            if (matchLen == length)
            {
                for (int i = 0; i < matchLen; i++)
                {
                    putchar(line[start]);
                    start++;
                }
                putchar('\n');
                free(line);
                return NULL;
            }
        }
    }
    free(line);
    return NULL;
}