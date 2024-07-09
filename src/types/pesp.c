#include "pesp.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

pesp_t *pesp_parse_file(char *file_path) {
    FILE *handle = fopen(file_path, "r");
    assert(handle != NULL && "Can't open file");
    char *buf = malloc(BUF_LIMIT);
    int capacity = 16;
    int index = 0;
    int n = 0;
    int T = 0;

    // Process first line
    fgets(buf, BUF_LIMIT, handle);
    sscanf(buf, "%d %d %d", &capacity, &n, &T);

    constraint_t *cons = malloc(capacity * sizeof(constraint_t));
    while (fgets(buf, BUF_LIMIT, handle) != NULL) {
        constraint_t con;
        sscanf(buf, "%d; %d; %d; %d; %d; %d", &con.id, &con.p_i, &con.p_j, &con.lower_bound, &con.upper_bound,
               &con.weight);
        cons[index++] = con;
    }

    fclose(handle);

    return pesp_init(T, n, cons, capacity);
}

pesp_t *pesp_init(int period, int n, constraint_t *cons, int len) {

    pesp_t *self = malloc(sizeof(pesp_t));
    self->constaints = cons;
    self->constaint_len = len;
    self->potentials = malloc(n * sizeof(int));
    self->potential_len = n;
    self->period = period;

    return self;
}

pesp_result_t* pesp_result_init(int* array, int n) {
    pesp_result_t* self = malloc(sizeof(pesp_result_t));
    self->potentials = array;
    self->potential_len = n;

    return self;
}

char* pesp_result_to_str(pesp_result_t* self) {
    char* str = malloc(BUF_LIMIT);
    int offset = 0;
    offset += sprintf(str + offset, "[");
    for(int i = 0; i < self->potential_len - 1; i++) {
        offset += sprintf(str + offset, "%d, ", self->potentials[i]);
    }

    offset += sprintf(str + offset, "%d", self->potentials[self->potential_len - 1]);
    sprintf(str + offset, "]");

    return str;
}

void pesp_result_free(pesp_result_t* self) {
    free(self->potentials);
    free(self);
}

char *constaint_to_str(constraint_t *self) {
    char *buf = malloc(BUF_LIMIT * sizeof(char));
    // memset(buf, 0, BUF_LIMIT);

    sprintf(buf, "[%d, %d, %d, %d]", self->p_i, self->p_j, self->lower_bound, self->upper_bound);

    return buf;
}

char *pesp_to_str(pesp_t *self) {
    char *buf = malloc(BUF_LIMIT * BUF_LIMIT * sizeof(char));
    // sprintf(buf, "{ n = %d, T = %d }", self->potential_len, self->period);

    int next = 0;
    for (int i = 0; i < self->constaint_len; i++) {
        char *str = constaint_to_str(&(self->constaints[i]));
        next += sprintf(buf + next, "%s\n", str);

        free(str);
    }

    return buf;
}

void pesp_free(pesp_t *pesp) {
    free(pesp->potentials);
    free(pesp->constaints);
    free(pesp);
}
