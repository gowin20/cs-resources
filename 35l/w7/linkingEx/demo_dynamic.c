#include <dlfcn.h>
#include <stdlib.h>
#include <stdio.h>


int main(void) {
    const char *error;
    void (*demo_function)(void);
    void *module = dlopen("libhello.so", RTLD_LAZY);
    if (!module) {
        fprintf(stderr, "Couldn't open libhello.so: %s\n", dlerror());
        exit(1);
    }

    demo_function = dlsym(module, "hello");

    if ((error = dlerror())) {
        fprintf(stderr, "Couldn't find hello: %s\n", error);
        exit(1);
    }

    (*demo_function)();

    dlclose(module);
    return 0;
}

