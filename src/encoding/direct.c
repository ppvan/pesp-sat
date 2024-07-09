#include <math.h>

static int pair(int x, int y) {
    if (x < y) {
        return y * y + x;
    } else {
        return x*x + x + y;
    }
}

static void unpair(int z, int*x, int*y) {
    int tmp = floor(sqrt(z));

    if (z < tmp * tmp + tmp) {
        *x = z - tmp * tmp;
        *y = tmp;
    } else {
        *x = tmp;
        *y = z - tmp * tmp - tmp;
    }

}