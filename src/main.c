#include "../third-party/kissat/src/kissat.h"
#include "solver/binomial.h"
#include "types/pesp.h"
#include <stdio.h>

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
    z = z - 1;
    int tmp = floor(sqrt(z));

    if (z < tmp * tmp + tmp) {
        *x = z - tmp * tmp;
        *y = tmp;
    } else {
        *x = tmp;
        *y = z - tmp * tmp - tmp;
    }
}

typedef struct {
    int i;
    int j;

    int a;
    int b;
} contraint_t;

// Direct encode 0 <= var < bound, var in Z
void encode_bound(kissat *s, int var, int bound) {
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

bool next_shuffle(int *a, int n, int T) {
    for (int i = n - 1; i >= 0; i--) {
        if (a[i] < T - 1) {
            a[i]++;
            return true;
        }
        a[i] = 0;
    }
    return false;
}

int *naiive_solve(int n, int T, contraint_t *cons, int len) {

    int *array = calloc(n, sizeof(int));
    while (next_shuffle(array, n, T)) {
        bool is_valid = true;
        // for (int i = 0; i < n; i++) {
        //     printf("%d ", array[i]);
        // }
        // printf("\n");

        for (int i = 0; i < len; i++) {
            int temp = array[cons[i].j] - array[cons[i].i];
            int low = (temp - cons[i].b) / T;
            int high = (temp - cons[i].a) / T;
            bool has_chance = false;

            for (int j = low; j <= high; j++) {
                int a = cons[i].a + j * T;
                int b = cons[i].b + j * T;

                if (temp >= a && temp <= b) {
                    has_chance = true;
                    break;
                }
            }

            if (!has_chance) {
                is_valid = false;
                break;
            }
        }

        if (is_valid) {
            return array;
        }
    }

    return NULL;
}

bool is_valid_solution(pesp_t *pesp, pesp_result_t *solution) {

    int *arr = solution->potentials;
    int n = pesp->potential_len;
    int T = pesp->period;
    constraint_t *cons = pesp->constaints;
    int len = pesp->constaint_len;

    for (int k = 0; k < len; k++) {
        int i = cons[k].p_i;
        int j = cons[k].p_j;
        int a = cons[k].lower_bound;
        int b = cons[k].upper_bound;

        int temp = arr[j] - arr[i];

        int low = (temp - b) / T;
        int high = (temp - a) / T;
        bool has_chance = false;

        for (int jj = low; jj <= high; jj++) {
            int a_delta = a + jj * T;
            int b_delta = b + jj * T;

            if (temp >= a_delta && temp <= b_delta) {
                has_chance = true;
                break;
            }
        }

        if (!has_chance) {
            return false;
        }
    }

    return true;
}

// int sat = kissat_solve(solver);
// 10 => UNSAT
// 20 => SAT

int main(int argc, char *argv[]) {
    /**
    V = {A, B, C};
    A = C = {a1, a2, a3};
    T = 10
    a1 = ((A, B), [3, 5]) -> [i, j, a, b]
    a2 = ((B, C), [2, 2])
    a3 = ((C, A), [2, 4])
    */

    char *path = "./data/simple/test1.txt";
    pesp_t *pesp = pesp_parse_file(path);
    char *str = pesp_to_str(pesp);
    printf("%s\n\n", str);

    pesp_result_t *solution = binominal_solve(pesp);

    if (solution != NULL) {
        bool valid = is_valid_solution(pesp, solution);
        if (valid) {
            printf("OK\n");
        } else {
            printf("Invalid\n");
        }

        char *str = pesp_result_to_str(solution);
        printf("%s\n", str);
        free(str);
        pesp_result_free(solution);
    } else {
        printf("Failed\n");
    }

    free(str);
    pesp_free(pesp);
}