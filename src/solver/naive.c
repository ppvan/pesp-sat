#include "naive.h"

#include <stdbool.h>
#include <stdlib.h>

static bool next_shuffle(int *a, int n, int T) {
    for (int i = n - 1; i >= 0; i--) {
        if (a[i] < T - 1) {
            a[i]++;
            return true;
        }
        a[i] = 0;
    }
    return false;
}

pesp_result_t* naive_solve(pesp_t* pesp) {

    int n = pesp->potential_len;
    int T = pesp->period;
    constraint_t* cons = pesp->constaints;
    int len = pesp->constaint_len;

    int *array = calloc(n, sizeof(int));
    while (next_shuffle(array, n, T)) {
        bool is_valid = true;
        for (int i = 0; i < len; i++) {
            int temp = array[cons[i].p_j] - array[cons[i].p_i];
            int low = (temp - cons[i].lower_bound) / T;
            int high = (temp - cons[i].upper_bound) / T;
            bool has_chance = false;

            for (int j = low; j <= high; j++) {
                int a = cons[i].lower_bound + j * T;
                int b = cons[i].upper_bound + j * T;

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
            return pesp_result_init(array, n);
        }
    }

    return NULL;
}
