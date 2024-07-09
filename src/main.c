#include "../third-party/kissat/src/kissat.h"
#include "solver/binomial.h"
#include "types/pesp.h"
#include <assert.h>
#include <stdio.h>

#include <math.h>
#include <stdbool.h>
#include <stdlib.h>

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

char *shift_args(int *argc, char ***argv)
{
    assert(*argc > 0);
    char *result = **argv;
    *argc -= 1;
    *argv += 1;
    return result;
}

int main(int argc, char *argv[]) {
    /**
    V = {A, B, C};
    A = C = {a1, a2, a3};
    T = 10
    a1 = ((A, B), [3, 5]) -> [i, j, a, b]
    a2 = ((B, C), [2, 2])
    a3 = ((C, A), [2, 4])
    */


    char* program = shift_args(&argc, &argv);

    if (argc <= 0) {
        printf("%s <input_file>\n", program);
        return 1;
    }

    char *path = shift_args(&argc, &argv);

    pesp_t *pesp = pesp_parse_file(path);

    pesp_result_t *solution = binominal_solve(pesp);

    if (solution != NULL) {
        bool valid = is_valid_solution(pesp, solution);
        if (valid) {
            printf("OK\n");
        } else {
            printf("Invalid\n");
        }

        // char *result_str = pesp_result_to_str(solution);
        // printf("%s\n", result_str);
        // free(result_str);
        // pesp_result_free(solution);
    } else {
        printf("Failed\n");
    }

    // free(str);
    pesp_free(pesp);
}