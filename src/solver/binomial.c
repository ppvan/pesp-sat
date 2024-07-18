
#include "binomial.h"
#include "sat.h"
#include <kissat.h>

#include <math.h>
#include <stdbool.h>
#include <stdlib.h>

enum { UNSATISFIABLE = 20, SATISFIABLE = 10 };

static int pair(int x, int y) {
    if (x < y) {
        return y * y + x + 1;
    } else {
        return x * x + x + y + 1;
    }
}

static void unpair(int z, int *x, int *y) {
    z -= 1;
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
static void encode_bound(sat_t *s, int var, int bound) {
    for (int i = 0; i < bound; i++) {
        int index = pair(var, i);
        // printf("index = %d\n", index);
        sat_add(s, index);
    }
    sat_add(s, 0);

    for (int i = 0; i < bound; i++) {
        for (int j = i + 1; j < bound; j++) {
            int index1 = pair(var, i);
            int index2 = pair(var, j);

            sat_add(s, -index1);
            sat_add(s, -index2);
            sat_add(s, 0);
        }
    }
}

static void encode_contraint(sat_t *s, constraint_t *con, int T) {
    for (int i = 0; i < T; i++) {
        for (int j = 0; j < T; j++) {

            int time_contraint = j - i;
            int low = (time_contraint - con->upper_bound) / T;
            int high = (time_contraint - con->lower_bound) / T;
            bool has_chance = false;

            for (int jj = low; jj <= high; jj++) {
                int a = con->lower_bound + jj * T;
                int b = con->upper_bound + jj * T;

                if (time_contraint >= a && time_contraint <= b) {
                    has_chance = true;
                    break;
                }
            }

            if (has_chance)
                continue;

            int index1 = pair(con->p_i, i);
            int index2 = pair(con->p_j, j);

            sat_add(s, -index1);
            sat_add(s, -index2);
            sat_add(s, 0);
        }
    }
}

static int decode_bound(sat_t *s, int var, int bound) {
    for (int i = 0; i < bound; i++) {
        int index = pair(var, i);
        int value = sat_value(s, index);
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
    sat_t *solver = sat_init();

    for (int i = 0; i < n; i++) {
        encode_bound(solver, i, T);
    }

    // encode contraints
    for (int i = 0; i < len; i++) {
        encode_contraint(solver, &cons[i], T);
    }

    // solve
    bool satisfiable = sat_solve(solver);
    if (!satisfiable) {
        sat_free(solver);
        return NULL;
    }

    // extract result
    int *ans = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        int value = decode_bound(solver, i, T);
        ans[i] = value;
    }

    sat_free(solver);
    return pesp_result_init(ans, n);
}
