
#include "binomial.h"
#include <assert.h>
#include <kissat.h>

#include <math.h>
#include <stdbool.h>
#include <stdlib.h>

enum { UNSATISFIABLE = 20, SATISFIABLE = 10 };

static int pair(int x, int y) {
    if (x < y) {
        return y * y + x;
    } else {
        return x * x + x + y;
    }
}

static void unpair(int z, int *x, int *y) {
    int tmp = floor(sqrt(z));

    if (z < tmp * tmp + tmp) {
        *x = z - tmp * tmp;
        *y = tmp;
    } else {
        *x = tmp;
        *y = z - tmp * tmp - tmp;
    }
}

// Direct encode 0 <= var < bound, var in Z
static void encode_bound(kissat *s, int var, int bound) {
    for (int i = 0; i < bound; i++) {
        int index = pair(var, i);
        // printf("index = %d\n", index);
        kissat_add(s, index);
    }
    kissat_add(s, 0);

    for (int i = 0; i < bound; i++) {
        for (int j = i + 1; j < bound; j++) {
            int index1 = pair(var, i);
            int index2 = pair(var, j);

            kissat_add(s, -index1);
            kissat_add(s, -index2);
            kissat_add(s, 0);
        }
    }
}

static void encode_contraint(kissat *s, constraint_t *con, int T) {
    for (int i = 0; i < T; i++) {
        for (int j = 0; j < T; j++) {

            int temp = j - i;
            int low = (temp - con->upper_bound) / T;
            int high = (temp - con->lower_bound) / T;
            bool has_chance = false;

            for (int jj = low; jj <= high; jj++) {
                int a = con->lower_bound + jj * T;
                int b = con->upper_bound + jj * T;

                if (temp >= a && temp <= b) {
                    has_chance = true;
                    break;
                }
            }

            if (has_chance)
                continue;

            int index1 = pair(con->p_i, i);
            int index2 = pair(con->p_j, j);

            kissat_add(s, -index1);
            kissat_add(s, -index2);
            kissat_add(s, 0);
        }
    }
}

static int decode_bound(kissat *s, int var, int bound) {
    for (int i = 0; i < bound; i++) {
        int index = pair(var, i);
        int value = kissat_value(s, index);
        if (value == index) {
            return i;
        }
    }

    return -1;
}

pesp_result_t *binominal_solve(pesp_t *pesp) {

    // encode potentials
    int n = pesp->potential_len;
    int T = pesp->period;
    int len = pesp->constaint_len;
    constraint_t *cons = pesp->constaints;
    kissat *s = kissat_init();
    kissat_set_option(s, "quiet", 1);
    kissat_set_option(s, "sat", 1);

    for (int i = 1; i <= n; i++) {
        encode_bound(s, i, T);
    }

    // encode contraints

    for (int i = 0; i < len; i++) {
        encode_contraint(s, &cons[i], T);
    }

    // solve

    int result = kissat_solve(s);
    if (result == UNSATISFIABLE) {
        kissat_terminate(s);
        return NULL;
    }

    // extract result
    int *ans = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        int value = decode_bound(s, i, T);
        ans[i] = value;
    }

    kissat_terminate(s);
    return pesp_result_init(ans, n);
}
