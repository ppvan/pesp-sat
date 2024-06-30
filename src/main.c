#include<stdio.h>
#include "../third-party/kissat/src/kissat.h"

int main(int argc, char* argv[]) {
    const char* version = kissat_version();

    printf("%s\n", version);
}