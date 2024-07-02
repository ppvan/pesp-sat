#include "../third-party/kissat/src/kissat.h"
#include "types/vec.h"
#include <stdio.h>

#include <math.h>

int foo(int x, int y) {
    if (x > y) {
        return x * x + x + y;
    } else {
        return y * y + x;
    }
}

void inverse_foo(int *x, int *y, int z) {
    int a = floor(sqrt(z));
    int b = z - a * a;

    if (b < a) {
        *x = b;
        *y = a;
    } else {
        *x = a;
        *y = b - a;
    }
}

int main(int argc, char *argv[]) {
    const char *version = kissat_version();

    for (int i = 1; i < 20; i++) {
        for (int j = 1; j < 20; j++) {
            int z = foo(i, j);
            int x = -1;
            int y = -1;

            inverse_foo(&x, &y, z);

            printf("(%d, %d) -> %d -> (%d, %d)\n", i, j, z, x, y);
        }
    }
}