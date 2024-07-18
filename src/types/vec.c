#include "vec.h"
#include <stdlib.h>

#define DEFAULT_SIZE 16



vec_t* vec_init() {
    vec_t* vec = malloc(sizeof(vec_t));
    vec->data = malloc(DEFAULT_SIZE * sizeof(int));
    vec->capacity = DEFAULT_SIZE;
    vec->size = 0;

    return vec;
}

void vec_destroy(vec_t* vec) {
    free(vec->data);
    vec->data = NULL;
}

void vec_push_back(vec_t* vec, int value) {

    if (vec->size >= vec->capacity) {
        vec->capacity *= 2;
        vec->data = realloc(vec->data, vec->capacity * sizeof(int));
    }

    vec->data[vec->size++] = value;
}