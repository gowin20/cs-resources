#include "computechar.h"
#include <dlfcn.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
    if (argc != 4) 
    { exit(1); }
    if (strcmp(argv[1],"add") && strcmp(argv[1],"sub"))
    { exit(1); }
    if (strlen(argv[2]) != strlen(argv[3]))
    { exit(1); }

    void *lib_handle;
    char *error;
    int (*operation)(char*,char*);

    if (!strcmp(argv[1],"add"))
    {
        lib_handle = dlopen("libaddstr.so", RTLD_LAZY);
        if (!lib_handle) { 
            printf("error reading file\n");
            exit(1); 
        }
        operation = dlsym(lib_handle, "addStr");
        error = dlerror();
    }
    else
    {
        lib_handle = dlopen("libsubstr.so", RTLD_LAZY);
        if (!lib_handle) { 
            printf("error reading sub file\n");
            exit(1); 
        }
        operation = dlsym(lib_handle, "subStr");
        error = dlerror();
    }
    if (error != NULL)
    {
        fprintf(stderr, error);
        exit(1);
    }
    int output = operation(argv[2],argv[3]);
    dlclose(lib_handle);

    printf("%d\n",output);
    return 0;
}