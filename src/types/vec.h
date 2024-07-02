#ifndef VEC_H
#define VEC_H

#include <stddef.h>

typedef struct {
    int* data;
    size_t size;
    size_t capacity;
} Vec;


Vec vec_init(void);
void vec_destroy(Vec vec);
Vec vec_push_back(Vec vec, int value);
#endif // VEC_H