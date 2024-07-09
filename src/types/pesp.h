#ifndef _PESP_H_
#define _PESP_H_
#define BUF_LIMIT 2048


#include <stdio.h>
typedef struct {
    int id;
    int p_i;
    int p_j;

    int lower_bound;
    int upper_bound;
    int weight;
} constraint_t;

typedef struct {
    int period;

    int* potentials;
    int potential_len;

    constraint_t* constaints;
    int constaint_len;
} pesp_t;

typedef struct {
    int* potentials;
    int potential_len;
} pesp_result_t;


pesp_t* pesp_parse_file(char* filepath);
pesp_t* pesp_init(int period, int n, constraint_t* cons, int len);
char* pesp_to_str(pesp_t* self);
char* constaint_to_str(constraint_t* self);
void pesp_free(pesp_t* self);

pesp_result_t* pesp_result_init(int* array, int n);
char* pesp_result_to_str(pesp_result_t *self);
void pesp_result_free(pesp_result_t* self);

#endif