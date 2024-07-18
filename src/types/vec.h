#ifndef VEC_H
#define VEC_H

#include <stddef.h>

typedef struct {
    int* data;
    size_t size;
    size_t capacity;
} vec_t;


vec_t* vec_init(void);
void vec_destroy(vec_t* vec);
void vec_push_back(vec_t* vec, int value);
#endif // VEC_H