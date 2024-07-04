#include "naive.h"

#include <stdbool.h>
#include <stdlib.h>

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
