#include "../../third-party/kissat/src/kissat.h"
#include "../types/vec.h"
#include <cstddef>

/*
    x, 1 in [1, 2, 3] = direct_encode([1, 2, 3]) --- [lit1, lit2, ...., litn]
    y, [tag] in [0, 1, 2] = direct_encode([2, 3, 5]). 2^2 * 2 + 2 * 3 + 5

    x1, tag = 1, x1 in [1;3] -> [1, 2, 3], top = 4
    x2, tag = 4, x2 in [1;4] -> [4, 5, 6, 7]

    map[x2][4] = lit

    x1 != x2?
    x1 = 1 => not x2 = 1
    x1 = 2 => not x2 = 2
*/
//

int cantor_pairing(int x, int y);
int cantor_pairing_inv(int z, int* x, int* y);


void direct_potential(kissat *solver, int period, int start) {

    for (size_t i = 0; i < period; i++) {
        kissat_add(solver, start + i);
    }
    kissat_add(solver, 0);

    for (size_t i = 0; i < period; i++) {
        for (size_t j = i + 1; j < period; j++) {
            kissat_add(solver, -(start + i));
            kissat_add(solver, -(start + j));
            kissat_add(solver, 0);
        }
    }

}
