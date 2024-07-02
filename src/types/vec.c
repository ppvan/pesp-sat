#include "vec.h"
#include <stdlib.h>

#define DEFAULT_SIZE 16


Vec vec_init() {
    Vec vec;
    vec.data = malloc(DEFAULT_SIZE * sizeof(int));
    vec.capacity = DEFAULT_SIZE;
    vec.size = 0;

    return vec;
}

void vec_destroy(Vec vec) {
    free(vec.data);
    vec.data = NULL;
}

Vec vec_push_back(Vec vec, int value) {

    if (vec.size >= vec.capacity) {
        vec.capacity *= 2;
        vec.data = realloc(vec.data, vec.capacity * sizeof(int));
    }

    vec.data[vec.size++] = value;

    return vec;
}